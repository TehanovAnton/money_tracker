# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Layouts
          module IFormInput
            def form_input(empty_field_message, success_field_entrance_text, field, allow_nil: false)
              return messages << empty_field_message if !inputs[field] && !allow_nil

              create_form_input(form_input_factory(field), field)
              messages << success_field_entrance_text
              list_all_actions
              messages.flatten!
            end

            def create_form_input(form_input_mpdel, field)
              form_input_mpdel.create(form_id: spreadsheet_form.id, field => inputs[field])
            end

            def form_input_factory(_field)
              raise StandardError, 'Not Implemented'
            end
          end

          class AddExpenseLayout < Base
            include IFormInput

            FIELD_FORM_INPUT_MAP = {
              date: DateFormInput,
              range: RangeFormInput,
              money: MoneyFormInput,
              category: CategoryFormInput,
              comment: CommentFormInput
            }.freeze

            integer :spreadsheet_id, default: nil
            string :date, default: nil
            string :range, default: nil
            float :money, default: nil
            string :category, default: nil
            string :comment, default: nil

            define_action(:list_all_actions, 'Доступные действия')
            define_action(:enter_date, 'Ввести дату')
            define_action(:enter_range, 'Ввести диапазон')
            define_action(:enter_money, 'Ввести сумму')
            define_action(:enter_category, 'Ввести категорию')
            define_action(:enter_comment, 'Ввести коментарий')
            define_action(:publish_expense, 'Опубликовать рассход')
            define_action(:back_to_index, 'Назад')

            private

            def enter_date
              form_input('Пустая дата', 'Дата введена', :date)
            end

            def enter_range
              form_input('Пустой диапазон', 'Диапазон введен', :range)
            end

            def enter_money
              form_input('Пустая сумма', 'Сумма введена', :money)
            end

            def enter_category
              form_input('Пустая категория', 'категория введена', :category)
            end

            def enter_comment
              form_input(nil, nil, :comment, allow_nil: true)
            end

            def publish_expense
              params = ::Spreadsheets::ParamsBuilder.run!(spreadsheet_form: spreadsheet_form)
              upsert_result = ::Spreadsheets::UpsertService.run(params: params)

              handle_messages do
                upsert_result.valid? ? 'Расход опубликован' : 'Не удалось опубликовать расход'
              end

              list_all_actions
            end

            def back_to_index
              handle_messages { index_layout.run!(bot: bot, user: user, action_name: :list_all_actions) }
            end

            def index_layout
              layouts_factory(layout_name: :list_tables)
            end

            def spreadsheet_form
              @spreadsheet_form ||= SpreadsheetForm.find_or_create_by(user: user, spreadsheet_id: spreadsheet.id)
            end

            def form_input_factory(field)
              FIELD_FORM_INPUT_MAP[field]
            end

            def spreadsheet
              @spreadsheet ||= Spreadsheet.find(chat_context.spreadsheet_id)
            end

            def chat_context
              @chat_context ||= ChatContext.find_by(user_id: user.id)
            end
          end
        end
      end
    end
  end
end

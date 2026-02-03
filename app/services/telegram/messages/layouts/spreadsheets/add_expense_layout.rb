# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
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
            money: MoneyFormInput,
            category: CategoryFormInput,
            comment: CommentFormInput
          }.freeze

          integer :spreadsheet_id, default: nil
          string :date, default: nil
          float :money, default: nil
          string :category, default: nil
          string :comment, default: nil

          define_action(:list_all_actions, 'Доступные действия')
          define_action(:enter_date, 'Ввести дату')
          define_action(:enter_money, 'Ввести сумму')
          define_action(:enter_category, 'Ввести категорию')
          define_action(:enter_comment, 'Ввести коментарий')

          private

          def enter_date
            form_input('Пустая дата', 'Дата введена', :date)
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

          def spreadsheet_form
            @spreadsheet_form ||= SpreadsheetForm.find_or_create_by(user: user, spreadsheet_id: spreadsheet_id)
          end

          def form_input_factory(field)
            FIELD_FORM_INPUT_MAP[field]
          end
        end
      end
    end
  end
end

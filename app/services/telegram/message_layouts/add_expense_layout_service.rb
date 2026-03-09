# frozen_string_literal: true

module Telegram
  module MessageLayouts
    module IFormInput
      def form_input(empty_field_message, success_field_entrance_text, field, allow_nil: false)
        return messages << empty_field_message if !inputs[field] && !allow_nil

        create_form_input(form_input_factory(field), field)
        messages << success_field_entrance_text
        list_all_actions
        messages.flatten!
      end

      def create_form_input(form_input_model, field)
        form_input_model.find_or_create_by(form_id: spreadsheet_form.id).update(field => inputs[field])
      end

      def form_input_factory(_field)
        raise StandardError, 'Not Implemented'
      end
    end

    class AddExpenseLayoutService < BaseService
      include IFormInput

      FIELD_FORM_INPUT_MAP = {
        date: DateFormInput,
        range: RangeFormInput,
        money: MoneyFormInput,
        category: CategoryFormInput,
        comment: CommentFormInput
      }.freeze

      ENTER_PARAMS_MSG = <<~MSG
        Ввести параметры #
        n) --date 01.02.2025 --money 1.2 --category "Продукты" --comment "за хлеб""
      MSG

      integer :spreadsheet_id, default: nil
      string :date, default: nil
      string :range, default: nil
      float :money, default: nil
      string :category, default: nil
      string :comment, default: nil

      define_action(:list_all_actions, 'Доступные действия')
      define_action(:enter_all, ENTER_PARAMS_MSG)
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

      def enter_all
        return add_empty_input_message('Пустая дата') unless inputs[:date]
        return add_empty_input_message('Пустая сумма') unless inputs[:money]
        return add_empty_input_message('Пустая категория') unless inputs[:category]

        create_form_input(form_input_factory(:date), :date)
        create_form_input(form_input_factory(:money), :money)
        create_form_input(form_input_factory(:category), :category)
        create_form_input(form_input_factory(:comment), :comment) if inputs[:comment].present?

        publish_expense
      end

      def publish_expense
        params = ::Spreadsheets::ParamsBuilderService.run!(spreadsheet_form: spreadsheet_form)
        upsert_result = ::Spreadsheets::UpsertService.run(params: params)

        handle_messages do
          upsert_result.valid? ? 'Расход опубликован' : 'Не удалось опубликовать расход'
        end

        list_all_actions
      end

      def back_to_index
        handle_messages { index_layout.run!(bot: bot, user: user, action_name: :list_all_actions) }
      end

      def add_empty_input_message(message)
        messages << message
        list_all_actions
        messages.flatten!
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
        @chat_context ||= user.chat_context
      end
    end
  end
end

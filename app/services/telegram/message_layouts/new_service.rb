# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class NewService < BaseService
      string :document_id, default: nil
      string :expense_range, default: nil

      ENTER_TABLE_PARAMS_MSG = <<~MSG
        Ввести параметры таблицы # n) --document_id <value> --expense_range <value>
      MSG

      define_action(:enter_spreadsheets_params, ENTER_TABLE_PARAMS_MSG)
      define_action(:list_all_actions, 'Доступные действия')
      define_action(:back_to_index, 'Назад')

      private

      def back_to_index
        handle_messages do
          layouts_factory(layout_name: :index).run!(bot: bot, user: user, action_name: :list_all_actions)
        end
      end

      def enter_spreadsheets_params
        unless valid_spreadsheets_params? && spreadsheet.persisted?
          messages << 'Невалидные данные таблицы'
          return handle_messages do
            layouts_factory(layout_name: :new).run!(bot: bot, user: user, action_name: :list_all_actions)
          end
        end

        messages << 'Таблица добавлена'
        handle_messages do
          layouts_factory(layout_name: :index).run!(bot: bot, user: user, action_name: :list_tables)
        end
      end

      def valid_spreadsheets_params?
        document_id.present? && expense_range.present?
      end

      def spreadsheet
        Spreadsheet.create(user: user, document_id: document_id, expense_range: expense_range)
      rescue StandardError
        Spreadsheet.new
      end
    end
  end
end

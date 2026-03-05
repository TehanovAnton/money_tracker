# frozen_string_literal: true

module Telegram
  module MessageLayouts
    module IDataActionsLayoutLayouts
      def add_expense_layout
        layouts_factory(layout_name: :add_expense)
      end
    end

    class DataActionsLayout < Base
      include IDataActionsLayoutLayouts

      string :document_id, default: nil

      define_action(:list_all_actions, 'Доступные действия')
      define_action(:add_expense, 'Добавить расход')
      define_action(:back, 'Назад')

      private

      def add_expense
        return messages << 'Пустой id таблицы' unless spreadsheet_id

        handle_messages do
          add_expense_layout.run!(
            bot: bot,
            user: user,
            spreadsheet_id: spreadsheet_id,
            action_name: :list_all_actions
          )
        end
      end

      def back
        handle_messages { list_tables_layout.run!(bot: bot, user: user, action_name: :list_all_actions) }
      end

      def list_tables_layout
        layouts_factory(layout_name: :list_tables)
      end

      def spreadsheet_id
        Spreadsheet.where(id: chat_context&.spreadsheet_id).pick(:id)
      end

      def chat_context
        @chat_context ||= user.chat_context
      end
    end
  end
end

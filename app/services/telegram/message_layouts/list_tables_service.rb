# frozen_string_literal: true

module Telegram
  module MessageLayouts
    module IListTablesLayouts
      def data_actions_layout
        layouts_factory(layout_name: :data_actions)
      end

      def delete_layout
        layouts_factory(layout_name: :delete)
      end

      def index_layout
        layouts_factory(layout_name: :index)
      end
    end

    class ListTablesService < BaseService
      include IListTablesLayouts

      string :document_id, default: nil

      define_action(:list_all_actions, 'Доступные действия')
      define_action(:list_tables, 'Список табилц')
      define_action(:data_actions, 'Внести данные в таблицу # <n>) <doc_id>')
      define_action(:delete_table, 'Удалить')
      define_action(:back_to_index, 'Назад')

      private

      def list_tables
        spreadsheets = Spreadsheet.where(user: user)
        return messages << 'Таблиц нет' unless spreadsheets.any?

        spreadsheets_ids = spreadsheets.map.with_index do |spreadsheet, idx|
          "#{idx + 1}) #{spreadsheet.document_id}"
        end.join("\n")

        cursor_action
        messages << spreadsheets_ids
      end

      def data_actions
        return messages << 'Пустой id таблицы' unless document_id
        return messages << 'Таблица не найдена' unless spreadsheet

        handle_messages do
          chat_context
          data_actions_layout.run!(bot: bot, user: user, document_id: document_id, action_name: :list_all_actions)
        end
      end

      def delete_table
        return messages << 'Пустой id таблицы' unless document_id

        handle_messages do
          delete_layout.run!(
            bot: bot, user: user, document_id: document_id, action_name: :enter_spreadsheets_params
          )
        end
      end

      def back_to_index
        handle_messages { index_layout.run!(bot: bot, user: user, action_name: :list_all_actions) }
      end

      def chat_context
        return ChatContext.create(spreadsheet_id: spreadsheet.id, user_id: user.id) unless user.chat_context

        user.chat_context.update!(spreadsheet_id: spreadsheet.id)
      end

      def spreadsheet
        @spreadsheet ||= Spreadsheet.find_by(user: user, document_id: document_id)
      end
    end
  end
end

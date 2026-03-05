# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class Delete < Base
      string :document_id, default: nil

      define_action(:enter_spreadsheets_params, 'Удалить')

      private

      def enter_spreadsheets_params
        unless valid_spreadsheets_params?
          messages << 'Невалидные данные таблицы'
          return handle_messages do
            layouts_factory(layout_name: :list_tables).run!(bot: bot, user: user, action_name: :list_all_actions)
          end
        end

        spreadsheet.destroy
        messages << 'Таблица удалена'

        messages << layouts_factory(layout_name: :index)
                    .run!(bot: bot, user: user, action_name: :list_all_actions)
        messages.flatten!
      end

      def valid_spreadsheets_params?
        document_id.present? && spreadsheet.present?
      end

      def spreadsheet
        Spreadsheet.find_by(document_id: document_id)
      end
    end
  end
end

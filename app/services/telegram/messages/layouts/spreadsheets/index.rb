# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Index < Base
          AVAILABLE_ACTIONS = {
            list_all_actions: { number: 0, method: :list_all_actions },
            list_tables: { number: 1, text: 'Мои таблицы', method: :list_tables },
            add_table: { number: 2, text: 'Добавить таблицу', method: :add_table },
            delete_table: { number: 3, text: 'Удалить таблицу', method: :delete_table }
          }.freeze

          private

          def list_tables
            spreadsheets = Spreadsheet.where(user: user)
            return messages << 'Таблиц нет' unless spreadsheets.any?

            spreadsheets_ids = spreadsheets.map.with_index do |spreadsheet, idx|
              "#{idx + 1}) #{spreadsheet.spreadsheet_id}"
            end.join("\n")

            messages << spreadsheets_ids
            messages << list_actions_text
          end

          def add_table
            New.run(bot: bot, user: user, action_number: '0')
          end

          def delete_table
            Delete.run!(bot: bot, user: user)
          end

          def available_actions
            AVAILABLE_ACTIONS
          end
        end
      end
    end
  end
end

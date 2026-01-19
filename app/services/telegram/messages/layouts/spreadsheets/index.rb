# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Index < Base
          AVAILABLE_ACTIONS = {
            0 => { method: :list_all_actions },
            1 => { method: :list_tables, text: 'Мои таблицы' },
            2 => { method: :add_table, text: 'Добавить таблицу' },
            3 => { method: :delete_table, text: 'Удалить таблицу' }
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
            messages << New.run!(bot: bot, user: user, action_number: '0')
            messages.flatten!
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

# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Index < Base
          class IndexError < StandardError; end
          class UnknownAction < IndexError; end
          class NoLayoutCursorsAction < IndexError; end
          class NoActionNumber < IndexError; end

          AVAILABLE_ACTIONS = {
            list_all_actions: { number: '0', method: :list_all_actions },
            list_tables: { number: '1', text: 'Мои таблицы', method: :list_tables },
            add_table: { number: '2', text: 'Добавить таблицу', method: :add_table },
            delete_table: { number: '3', text: 'Удалить таблицу', method: :delete_table }
          }.freeze

          def execute
            raise NoLayoutCursorsAction unless user_layout_cursor_action

            super
          rescue UnknownAction
            messages << 'Неизвестная команда'
            messages << list_actions_text
          rescue NoLayoutCursorsAction
            messages << 'Начните работу командой /start'
          end

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

          def cursor_action
            user.update!(layout_cursor_action: layout_cursor_action)
          rescue StandardError => _e
            # ignore
          end

          def layout_cursor_action
            LayoutAction.create!(user: user, layout: self.class.name, action: action)
          end

          def user_layout_cursor_action
            user.layout_cursor_action
          end
        end
      end
    end
  end
end

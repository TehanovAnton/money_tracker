# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class ListTables < Base
          string :spreadsheet_id, default: nil

          define_action(:list_all_actions, 'Доступные действия')
          define_action(:list_tables, 'Показать все')
          define_action(:edit_table, 'Изменить табилцу')
          define_action(:delete_table, 'Удалить')
          define_action(:back_to_index, 'Назад')

          private

          def list_tables
            spreadsheets = Spreadsheet.where(user: user)
            return messages << 'Таблиц нет' unless spreadsheets.any?

            spreadsheets_ids = spreadsheets.map.with_index do |spreadsheet, idx|
              "#{idx + 1}) #{spreadsheet.spreadsheet_id}"
            end.join("\n")

            cursor_action
            messages << spreadsheets_ids
          end

          def edit_table; end

          def delete_table
            return messages << 'Пустой id таблицы' unless spreadsheet_id

            messages << layouts_factory(layout_name: :delete)
                        .run!(bot: bot, user: user, spreadsheet_id: spreadsheet_id)
            messages.flatten!
          end

          def back_to_index
            messages << layouts_factory(layout_name: :index)
                        .run!(bot: bot, user: user, action_name: :list_all_actions)
            messages.flatten!
          end
        end
      end
    end
  end
end

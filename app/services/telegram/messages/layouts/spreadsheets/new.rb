# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class New < Base
          string :spreadsheet_id, default: nil

          define_action(:list_all_actions, 'Доступные действия')
          define_action(:enter_spreadsheet_id, 'Ввести id таблицы')
          define_action(:back_to_index, 'Назад')

          private

          def back_to_index
            messages << layouts_factory(layout_name: :index)
                        .run!(bot: bot, user: user, action_name: :list_all_actions)
            messages.flatten!
          end

          def enter_spreadsheet_id
            unless spreadsheet
              messages << 'Пустой Id таблицы'
              messages << layouts_factory(layout_name: :new)
                          .run!(bot: bot, user: user, action_name: :list_all_actions)
              return messages.flatten!
            end

            messages << 'Таблица добавлена'
            messages << layouts_factory(layout_name: :index)
                        .run!(bot: bot, user: user, action_name: :list_tables)
            messages.flatten!
          end

          def spreadsheet
            Spreadsheet.create(user: user, spreadsheet_id: spreadsheet_id)
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class New < Base
          AVAILABLE_ACTIONS = {
            0 => { method: :list_all_actions },
            1 => { method: :enter_spreadsheet_id, text: 'Ввести id таблицы' },
            2 => { method: :back_to_index, text: 'Назад' }
          }.freeze

          string :spreadsheet_id, default: nil

          private

          def back_to_index
            messages << Index.run!(bot: bot, user: user, action_number: '0')
            messages.flatten!
          end

          def enter_spreadsheet_id
            spreadsheet
            messages << 'Таблица добавлена'
            messages << Index.run!(bot: bot, user: user, action_number: 0)
            messages.flatten!
          end

          def spreadsheet
            Spreadsheet.create!(user: user, spreadsheet_id: spreadsheet_id)
          end

          def available_actions
            AVAILABLE_ACTIONS
          end
        end
      end
    end
  end
end

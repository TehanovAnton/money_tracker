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
            messages << Index.run!(bot: bot, user: user, action_number: 0)
            messages.flatten!
          end

          def enter_spreadsheet_id
            unless spreadsheet
              messages << 'Пустой Id таблицы'
              messages << New.run!(bot: bot, user: user, action_number: 0)
              return messages.flatten!
            end

            messages << 'Таблица добавлена'
            messages << Index.run!(bot: bot, user: user, action_number: 0)
            messages.flatten!
          end

          def spreadsheet
            Spreadsheet.create(user: user, spreadsheet_id: spreadsheet_id)
          rescue StandardError
            nil
          end

          def available_actions
            AVAILABLE_ACTIONS
          end

          def check_spreadsheet_id
            return if spreadsheet_id

            errors.add(:check_spreadsheet_id, 'Пустой id таблицы')
          end
        end
      end
    end
  end
end

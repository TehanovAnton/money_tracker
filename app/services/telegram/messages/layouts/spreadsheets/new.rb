# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class New < Base
          AVAILABLE_ACTIONS = {
            list_all_actions: { number: 0, method: :list_all_actions },
            enter_spreadsheet_id: { number: 1, text: 'Ввести id таблицы', method: :enter_spreadsheet_id },
            back_to_index: { number: 2, text: 'Назад', method: :back_to_index }
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

          def build_message
            text = ''

            available_actions.each_value do |layout_action|
              next unless layout_action[:text]

              text += "#{layout_action[:number]}) #{layout_action[:text]}\n"
            end

            text
          end

          def action_method
            available_actions[action][:method]
          end

          def input_parser
            NewInputParser
          end
        end
      end
    end
  end
end

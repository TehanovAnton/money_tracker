# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class New < Base
          class NewError < StandardError; end
          class UnknownAction < NewError; end
          class NoSpreadsheetId < NewError; end
          class NoActionNumber < NewError; end

          AVAILABLE_ACTIONS = {
            list_all_actions: { number: '0', method: :list_all_actions },
            enter_spreadsheet_id: { number: '1', text: 'Ввести id таблицы', method: :enter_spreadsheet_id }
          }.freeze

          string :spreadsheet_id, default: nil

          def execute
            super
          rescue NoSpreadsheetId
            messages << 'Пустой id таблицы'
            messages << list_actions_text
          rescue UnknownAction
            messages << 'Неизвестная команда'
            messages << list_actions_text
          end

          class << self
            def may_receive_inputs?
              true
            end
          end

          private

          def enter_spreadsheet_id
            raise NoSpreadsheetId unless spreadsheet_id

            spreadsheet
            messages << 'Таблица добавлена'
            Index.run!(bot: bot, user: user)
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

          def cursor_action
            user.update!(layout_cursor_action: layout_cursor_action)
          rescue StandardError => _e
            # ignore
          end

          def layout_cursor_action
            LayoutAction.create!(user: user, layout: self.class.name, action: action)
          end

          def action_method
            available_actions[action][:method]
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class New < ActiveInteraction::Base
          class NewError < StandardError; end
          class UnknownAction < NewError; end
          class NoSpreadsheetId < NewError; end
          class NoActionNumber < NewError; end

          AVAILABLE_ACTIONS = {
            list_all_actions: { number: '0' },
            enter_spreadsheet_id: { number: '1', text: 'Ввести id таблицы' }
          }.freeze

          object :bot, class: BotDecorators::BotDecorator
          record :user
          string :action_number, default: nil
          string :spreadsheet_id, default: nil

          def execute
            case action
            when :list_all_actions
              cursor_action
              bot.send_message(message)
            when :enter_spreadsheet_id
              raise NoSpreadsheetId if action == :enter_spreadsheet_id && !spreadsheet_id

              spreadsheet
              bot.send_message('Таблица добавлена')
              Index.run!(bot: bot, user: user)
            end
          rescue NoSpreadsheetId
            bot.send_message('Пустой id таблицы')
            bot.send_message(message)
          rescue UnknownAction
            bot.send_message('Неизвестная команда')
            bot.send_message(message)
          end

          private

          def spreadsheet
            Spreadsheet.create!(user: user, spreadsheet_id: spreadsheet_id)
          end

          def message
            @message ||= build_message
          end

          def build_message
            text = ''

            AVAILABLE_ACTIONS.each_value do |layout_action|
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
            AVAILABLE_ACTIONS[action][:method]
          end

          def action
            layout_action = AVAILABLE_ACTIONS.filter_map do |la|
              { name: la.first, number: la.last[:number] } if action_number == la.last[:number]
            end.last

            raise UnknownAction unless layout_action

            layout_action[:name]
          end
        end
      end
    end
  end
end

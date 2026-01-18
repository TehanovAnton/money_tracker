# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Delete < ActiveInteraction::Base
          LAOUT_ACTIONS = [
            { number: 1, name: :spreadsheet_id, text: 'Введите id таблицы' },
            { number: 2, name: :save, text: 'Сохранить' }
          ].freeze

          object :bot, class: BotDecorators::BotDecorator
          record :user
          symbol :action, default: :actions
          string :spreadsheet_id, default: nil

          def execute
            case action
            when :actions
              cursor_action
              bot.send_message(message)
            when :spreadsheet_id
              spreadsheet
              bot.send_message('Таблица добавлена')
              Index.run!(bot: bot, user: user)
            end
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

            LAOUT_ACTIONS.each do |layout_action|
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
        end
      end
    end
  end
end

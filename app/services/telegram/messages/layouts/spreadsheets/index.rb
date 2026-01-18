# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Index < ActiveInteraction::Base
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

          object :bot, class: BotDecorators::BotDecorator
          record :user
          string :action_number, default: nil

          def execute
            raise NoLayoutCursorsAction unless user_layout_cursor_action

            send(action_method)
          rescue UnknownAction
            bot.send_message('Неизвестная команда')
            bot.send_message(message)
          rescue NoLayoutCursorsAction
            bot.send_message('Начните работу командой /start')
          end

          private

          def list_all_actions
            cursor_action
            bot.send_message(message)
          end

          def list_tables
            spreadsheets = Spreadsheet.where(user: user)
            return bot.send_message('Таблиц нет') unless spreadsheets.any?

            spreadsheets_ids = spreadsheets.map(&:spreadsheet_id).join("\n")

            bot.send_message(spreadsheets_ids)
            bot.send_message(message)
          end

          def add_table
            New.run(bot: bot, user: user, action_number: '0')
          end

          def delete_table
            Delete.run!(bot: bot, user: user)
          end

          def action_method
            AVAILABLE_ACTIONS[action][:method]
          end

          def message
            @message ||= build_message
          end

          def build_message
            text = ''

            AVAILABLE_ACTIONS.each_value do |layout_action|
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

          def user_layout_cursor_action
            user.layout_cursor_action
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

# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Base < ActiveInteraction::Base
          integer :action_number
          record :user
          object :bot, class: BotDecorators::BotDecorator

          validate :check_action_number
          validate :check_user_layout_cursor_action

          def execute
            send(action_method)
            messages
          end

          private

          def list_all_actions
            cursor_action
            messages << list_actions_text
          end

          def check_action_number
            return if action_number.in?(available_actions.values.map { |v| v[:number] })

            errors.add(:action_number, 'Неизвестная команда')
          end

          def check_user_layout_cursor_action
            return if user.layout_cursor_action

            errors.add(:layout_cursor_action, 'Пользователь не имеет курсора')
          end

          def action
            layout_action = available_actions.filter_map do |la|
              if action_number == la.last[:number]
                {
                  name: la.first,
                  number: la.last[:number]
                }
              end
            end.last

            layout_action[:name]
          end

          def action_method
            available_actions[action][:method]
          end

          def available_actions
            raise StandardError, 'Not implemented'
          end

          def cursor_action
            user.update!(layout_cursor_action: layout_cursor_action(layout: self.class.name))
          end

          def layout_cursor_action(layout:)
            LayoutAction.create!(user: user, layout: layout)
          end

          def messages
            @messages ||= []
          end

          def list_actions_text
            text = ''

            available_actions.each_value do |layout_action|
              next if layout_action[:number] == '0'

              text += "#{layout_action[:number]}) #{layout_action[:text]}\n"
            end

            text
          end
        end
      end
    end
  end
end

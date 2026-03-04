# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module IDefineAction
          def define_action(method_name, text = nil)
            layout_actions[method_name] = { text: text }
          end

          def layout_actions
            @layout_actions ||= {}
          end

          def action_number_for(method_name)
            layout_actions.keys.index(method_name) + 1
          end

          def action_name_for(action_number)
            layout_actions.keys[action_number - 1]
          end
        end

        module IChooseAction
          def action_method
            return available_actions.keys[action_number - 1] if action_number

            action_name
          end
        end

        class Base < ActiveInteraction::Base
          extend IDefineAction
          include IChooseAction

          integer :action_number, default: nil
          symbol :action_name, default: nil
          record :user
          object :bot, class: Bot::BotDecorator
          string :spreadsheet_id, default: nil

          validate :check_action_number
          validate :check_user_layout_cursor_action

          def execute
            send(action_method)
            messages
          end

          def messages
            @messages ||= []
          end

          private

          def list_all_actions
            cursor_action
            messages << list_actions_text
          end

          def check_action_number
            return if available_actions[action_method].present?
            return if available_actions[action_name].present?

            errors.add(:action_number, 'Неизвестная команда')
            messages << self.class.run!(bot: bot, user: user, action_number: 0)
            messages.flatten!
          end

          def check_user_layout_cursor_action
            return if user.layout_cursor_action

            cursor_action
          end

          def available_actions
            @available_actions ||= self.class.layout_actions
          end

          def cursor_action
            user.update!(layout_cursor_action: layout_cursor_action(layout: self.class.name))
          end

          def layout_cursor_action(layout:)
            LayoutAction.find_or_create_by(user: user, layout: layout)
          end

          def list_actions_text
            text = ''

            available_actions.each_value.with_index do |options, idx|
              text += "#{idx + 1}) #{options[:text]}\n"
            end

            text
          end

          def layouts_factory(layout_name:)
            LayoutsFactory.run!(factory_name: layout_name)
          end

          def handle_messages
            messages << yield
            messages.flatten!
          end
        end
      end
    end
  end
end

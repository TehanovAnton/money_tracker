# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Base < ActiveInteraction::Base
          string :action_number, default: nil
          record :user
          object :bot, class: BotDecorators::BotDecorator

          def execute
            send(action_method)
            messages
          end

          class << self
            def may_receive_inputs?
              false
            end

            def inputs_parser
              LayoutInputParser
            end
          end

          private

          def action
            layout_action = available_actions.filter_map do |la|
              if action_number == la.last[:number]
                {
                  name: la.first,
                  number: la.last[:number]
                }
              end
            end.last

            raise UnknownAction unless layout_action

            layout_action[:name]
          end

          def action_method
            available_actions[action][:method]
          end

          def available_actions
            raise StandardError, 'Not implemented'
          end

          def messages
            @messages ||= []
          end

          def list_all_actions
            cursor_action

            messages << list_actions_text
          end

          def list_actions_text
            text = ''

            available_actions.each_value do |layout_action|
              text += "#{layout_action[:number]}) #{layout_action[:text]}\n"
            end

            text
          end
        end
      end
    end
  end
end

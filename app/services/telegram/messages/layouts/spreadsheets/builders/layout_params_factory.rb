# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Builders
          class LayoutParamsFactory < BaseFactory
            define(:enter_date, [{ name: :action_number }, { name: :date }]) do
              LayoutParamsBuilder
            end

            define(:enter_money, [{ name: :action_number }, { name: :money }]) do
              LayoutParamsBuilder
            end

            define(:enter_category, [{ name: :action_number }, { name: :category }]) do
              LayoutParamsBuilder
            end

            define(:enter_comment, [{ name: :action_number }, { name: :comment }]) do
              LayoutParamsBuilder
            end
          end
        end
      end
    end
  end
end

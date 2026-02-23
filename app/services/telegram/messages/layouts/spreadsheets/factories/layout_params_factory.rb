# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class LayoutParamsFactory < BaseFactory
            define(:enter_date, [{ name: :action_number }, { name: :date }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_range, [{ name: :action_number }, { name: :range }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_money, [{ name: :action_number }, { name: :money }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_category, [{ name: :action_number }, { name: :category }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_comment, [{ name: :action_number }, { name: :comment }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:publish_expense, [{ name: :action_number }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end
          end
        end
      end
    end
  end
end

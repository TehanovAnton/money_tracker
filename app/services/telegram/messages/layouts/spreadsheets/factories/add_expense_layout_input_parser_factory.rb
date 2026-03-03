# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class AddExpenseLayoutInputParserFactory < BaseFactory
            define(:list_all_actions) do
              Telegram::ActionInputParser
            end

            define(:back_to_index) do
              Telegram::ActionInputParser
            end

            define(:enter_date, value_alias: :date, kind: :date_input) do
              AddExpenseInputParser::Default
            end

            define(:enter_range, value_alias: :range, kind: :range_input) do
              AddExpenseInputParser::Default
            end

            define(:enter_money, value_alias: :money, kind: :money_input) do
              AddExpenseInputParser::Default
            end

            define(:enter_category, value_alias: :category, kind: :category_input) do
              AddExpenseInputParser::Default
            end

            define(:enter_comment, value_alias: :comment, kind: :comment_input) do
              AddExpenseInputParser::Default
            end

            define(:enter_all, :with_named_inputs, :date_input, :money_input, :category_input, :comment_input) do
              AddExpenseInputParser::WithNamedInputs
            end

            define(:publish_expense) do
              Telegram::ActionInputParser
            end
          end
        end
      end
    end
  end
end

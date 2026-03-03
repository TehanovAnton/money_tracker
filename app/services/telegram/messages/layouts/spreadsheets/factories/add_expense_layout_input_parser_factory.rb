# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class AddExpenseLayoutInputParserFactory < BaseFactory
            multi_define(
              :list_all_actions,
              :back_to_index,
              :publish_expense
            ) do
              Telegram::ActionInputParser
            end

            multi_define(
              { factory_name: :enter_date, named_options: { value_alias: :date, kind: :date_input } },
              { factory_name: :enter_range, named_options: { value_alias: :range, kind: :range_input } },
              { factory_name: :enter_money, named_options: { value_alias: :money, kind: :money_input } },
              { factory_name: :enter_category, named_options: { value_alias: :category, kind: :category_input } },
              { factory_name: :enter_comment, named_options: { value_alias: :comment, kind: :comment_input } }
            ) do
              AddExpenseInputParser::Default
            end

            define(:enter_all, :with_named_inputs, :date_input, :money_input, :category_input, :comment_input) do
              AddExpenseInputParser::WithNamedInputs
            end
          end
        end
      end
    end
  end
end

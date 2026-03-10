# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class AddExpenseLayoutInputParserFactory < BaseFactory
      multi_define(
        :list_all_actions,
        :back_to_index,
        :publish_expense
      ) do
        Telegram::ActionInputParser
      end

      multi_define(
        :enter_date,
        :enter_range,
        :enter_category,
        :enter_money,
        :enter_comment,
        enter_date: { named_options: { value_alias: :date, kind: :date_input } },
        enter_range: { named_options: { value_alias: :range, kind: :range_input } },
        enter_category: { named_options: { value_alias: :category, kind: :category_input } },
        enter_money: { named_options: { value_alias: :money, kind: :money_input } },
        enter_comment: { named_options: { value_alias: :comment, kind: :comment_input } }
      ) do
        AddExpenseInput::DefaultParser
      end

      define(:enter_all) do
        Telegram::CommonParser
      end
    end
  end
end

# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class AddExpenseLayoutParamsFactory < BaseFactory
      multi_define(
        :list_all_actions,
        :back_to_index
      ) do
        Telegram::MessageLayouts::Builders::DefaultLayoutParamsBuilder
      end

      multi_define(
        :action_input,
        :value_input,
        :enter_date,
        :enter_range,
        :enter_money,
        :enter_category,
        :enter_comment,
        :enter_all,
        :publish_expense,
        action_input: { inline_options: [[{ name: :action_number }]] },
        value_input: { inline_options: [[{ name: :action_number }, { name: :document_id }]] },
        enter_date: { inline_options: [[{ name: :action_number }, { name: :date }]] },
        enter_range: { inline_options: [[{ name: :action_number }, { name: :range }]] },
        enter_money: { inline_options: [[{ name: :action_number }, { name: :money }]] },
        enter_category: { inline_options: [[{ name: :action_number }, { name: :category }]] },
        enter_comment: { inline_options: [[{ name: :action_number }, { name: :comment }]] },
        enter_all: {
          inline_options: [[
            { name: :action_number },
            { name: :date },
            { name: :money },
            { name: :category },
            { name: :comment }
          ]]
        },
        publish_expense: { inline_options: [[{ name: :action_number }]] }
      ) do
        Telegram::MessageLayouts::Builders::LayoutParamsBuilder
      end
    end
  end
end

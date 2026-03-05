# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class AddExpenseLayoutTextPreparationFactory < BaseFactory
      multi_define(
        :list_all_actions,
        :back_to_index
      ) do
        Support::ActionNumberTextPreparationService
      end

      multi_define(
        :action_input,
        :value_input,
        :enter_date,
        :enter_range,
        :enter_money,
        :publish_expense,
        action_input: { named_options: { clean_white_space: true } },
        value_input: { named_options: { clean_white_space: true } },
        enter_date: { named_options: { clean_white_space: true } },
        enter_range: { named_options: { clean_white_space: true } },
        enter_money: { named_options: { clean_white_space: true } },
        publish_expense: { named_options: { clean_white_space: true } }
      ) do
        Support::TextPreparationService
      end

      multi_define(
        :enter_category,
        :enter_comment,
        :enter_all,
        enter_category: { named_options: { clean_white_space: false } },
        enter_comment: { named_options: { clean_white_space: false } },
        enter_all: { named_options: { clean_white_space: false } }
      ) do
        Support::TextPreparationService
      end
    end
  end
end

# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class DefaultLayoutParamsFactory < BaseFactory
      multi_define(
        :action_number,
        :value_input
      ) do
        Telegram::MessageLayouts::Builders::DefaultLayoutParamsBuilder
      end
    end
  end
end

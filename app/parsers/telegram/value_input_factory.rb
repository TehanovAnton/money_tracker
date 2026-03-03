# frozen_string_literal: true

module Telegram
  class ValueInputFactory < Telegram::Messages::Layouts::Spreadsheets::BaseFactory
    define(:default) do
      :default_value_input
    end

    define(:with_named_inputs) do
      :with_named_inputs_value_input
    end
  end
end

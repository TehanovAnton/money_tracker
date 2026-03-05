# frozen_string_literal: true

module Parsers
  class ParametersFactory < Telegram::MessageLayouts::BaseFactory
    define(:default) do
      Parsers::DefaultParameters
    end

    define(:with_named_inputs) do
      Parsers::WithNamedInputsParameters
    end
  end
end

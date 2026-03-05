# frozen_string_literal: true

module Parsers
  class ParametersFactory < Telegram::Messages::Layouts::Spreadsheets::BaseFactory
    define(:default) do
      Parsers::DefaultParameters
    end

    define(:with_named_inputs) do
      Parsers::WithNamedInputsParameters
    end
  end
end

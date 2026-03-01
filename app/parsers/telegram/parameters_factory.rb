# frozen_string_literal: true

module Telegram
  class ParametersFactory < Telegram::Messages::Layouts::Spreadsheets::BaseFactory
    define(:default) do
      Telegram::AddExpenseInputParser::DefaultParameters
    end

    define(:with_named_inputs) do
      Telegram::AddExpenseInputParser::WithNamedInputsParameters
    end
  end
end

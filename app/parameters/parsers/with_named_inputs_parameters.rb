# frozen_string_literal: true

module Parsers
  class WithNamedInputsParameters < Dry::Struct
    KindType = Telegram::AddExpenseInput::BaseParser::Types::Symbol.enum(:with_named_inputs)

    attribute :kind, KindType
    attribute :inline_parameters, Telegram::AddExpenseInput::BaseParser::Types::Array.default([].freeze)
    attribute :named_parameters, Telegram::AddExpenseInput::BaseParser::Types::Hash.default({}.freeze)
  end
end

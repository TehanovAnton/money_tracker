# frozen_string_literal: true

module Parsers
  class WithNamedInputsParameters < Dry::Struct
    KindType = Telegram::AddExpenseInputParser::BaseParser::Types::Symbol.enum(:with_named_inputs)

    attribute :kind, KindType
    attribute :inline_parameters, Telegram::AddExpenseInputParser::BaseParser::Types::Array.default([].freeze)
    attribute :named_parameters, Telegram::AddExpenseInputParser::BaseParser::Types::Hash.default({}.freeze)
  end
end

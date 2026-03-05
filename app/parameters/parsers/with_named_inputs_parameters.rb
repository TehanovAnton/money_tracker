# frozen_string_literal: true

module Parsers
  class WithNamedInputsParameters < Dry::Struct
    KindType = Telegram::AddExpenseInputParser::Base::Types::Symbol.enum(:with_named_inputs)

    attribute :kind, KindType
    attribute :inline_parameters, Telegram::AddExpenseInputParser::Base::Types::Array.default([].freeze)
    attribute :named_parameters, Telegram::AddExpenseInputParser::Base::Types::Hash.default({}.freeze)
  end
end

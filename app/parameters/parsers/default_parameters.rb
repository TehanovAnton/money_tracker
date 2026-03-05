# frozen_string_literal: true

module Parsers
  class DefaultParameters < Dry::Struct
    ALLOWED_PARSER_KINDS = %i[default].freeze
    ALLOWED_INPUT_KINDS = %i[date_input range_input money_input category_input comment_input].freeze

    KindType = Telegram::AddExpenseInputParser::Base::Types::Symbol.enum(*ALLOWED_PARSER_KINDS)
    InputKindType = Telegram::AddExpenseInputParser::Base::Types::Symbol.enum(*ALLOWED_INPUT_KINDS)
    InlineParametersType = Telegram::AddExpenseInputParser::Base::Types::Array.of(InputKindType)

    attribute :kind, KindType
    attribute :inline_parameters, InlineParametersType.default([].freeze)
    attribute :named_parameters, Telegram::AddExpenseInputParser::Base::Types::Hash.default({}.freeze)
  end
end

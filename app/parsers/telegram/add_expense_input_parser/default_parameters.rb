# frozen_string_literal: true

module Telegram
  module AddExpenseInputParser
    class DefaultParameters < Dry::Struct
      ALLOWED_PARSER_KINDS = %i[default].freeze
      ALLOWED_INPUT_KINDS = %i[date_input range_input money_input category_input comment_input].freeze

      KindType = Base::Types::Symbol.enum(*ALLOWED_PARSER_KINDS)
      InputKindType = Base::Types::Symbol.enum(*ALLOWED_INPUT_KINDS)
      InlineParametersType = Base::Types::Array.of(InputKindType)

      attribute :kind, KindType
      attribute :inline_parameters, InlineParametersType.default([].freeze)
      attribute :named_parameters, Base::Types::Hash.default({}.freeze)
    end
  end
end

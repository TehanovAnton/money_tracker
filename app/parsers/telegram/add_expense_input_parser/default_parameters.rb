class DefaultParameters < Dry::Struct
  ALLOWED_PARSER_KINDS = %i[default].freeze
  ALLOWED_INPUT_KINDS = %i[date_input range_input money_input category_input comment_input].freeze

  KindType = Types::Symbol.enum(*ALLOWED_PARSER_KINDS)
  InputKindType = Types::Symbol.enum(*ALLOWED_INPUT_KINDS)
  InlineParametersType = Types::Array.of(InputKindType)

  attribute :kind, KindType
  attribute :inline_parameters, InlineParametersType.default([].freeze)
  attribute :named_parameters, Types::Hash.default({}.freeze)
end
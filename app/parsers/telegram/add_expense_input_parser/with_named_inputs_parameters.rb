class WithNamedInputsParameters < Dry::Struct
  KindType = Types::Symbol.enum(:with_named_inputs)

  attribute :kind, KindType
  attribute :inline_parameters, Types::Array.default([].freeze)
  attribute :named_parameters, Types::Hash.default({}.freeze)
end
# frozen_string_literal: true

module Telegram
  module AddExpenseInputParser
    class WithNamedInputsParameters < Dry::Struct
      KindType = Base::Types::Symbol.enum(:with_named_inputs)

      attribute :kind, KindType
      attribute :inline_parameters, Base::Types::Array.default([].freeze)
      attribute :named_parameters, Base::Types::Hash.default({}.freeze)
    end
  end
end

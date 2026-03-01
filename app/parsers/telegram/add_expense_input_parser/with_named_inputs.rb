# frozen_string_literal: true

module Telegram
  module AddExpenseInputParser
    class WithNamedInputsParameters < Base
      attr_reader :value_alias, :kind, :input_kind, :params

      def initialize(kind, *inline_parameters, **named_parameters)
        resolved_kind = kind || :default
        @kind = resolved_kind

        @params = parameters_type.new(
          kind: resolved_kind,
          inline_parameters: inline_parameters,
          named_parameters: named_parameters.dup
        )

        super()
      end

      rule(:value_input) do
        with_named_inputs_value_input
      end

      rule(:with_named_inputs_value_input) do
        'Value input'
      end

      def parameters_type
        Telegram::ParametersFactory.run!(factory_name: kind, style: :const_keeper)
      end

      def value_input_rule_name
        Telegram::ValueInputFactory.run!(factory_name: kind, style: :const_keeper)
      end
    end
  end
end

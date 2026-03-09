# frozen_string_literal: true

module Telegram
  module AddExpenseInput
    class WithNamedInputsParser < BaseParser
      DEFAULT_NAMED_PARAMETER_ALIASES = {
        date: '--date',
        money: '--money',
        category: '--category',
        comment: '--comment'
      }.freeze

      attr_reader :kind, :params

      def initialize(kind, *inline_parameters, **named_parameters)
        resolved_kind = kind || :with_named_inputs
        @kind = resolved_kind
        @params = parameters_type.new(
          kind: resolved_kind,
          inline_parameters: inline_parameters,
          named_parameters: named_parameters.dup
        )
        super()
      end

      root(:value_input)

      rule(:value_input) do
        space >> with_named_inputs_value_input >> space
      end

      rule(:with_named_inputs_value_input) do
        action_number >>
          space >>
          date_parameter >>
          space >>
          money_parameter >>
          space >>
          category_parameter >>
          (space >> comment_parameter).maybe
      end

      rule(:action_number) { match('\d').repeat(1).as(:action_number) >> str(')') }

      rule(:space) { match('\s').repeat }

      rule(:date_parameter) do
        named_parameter(:date) >>
          space >>
          (match('\d').repeat(2) >> str('.') >> match('\d').repeat(2) >> str('.') >> match('\d').repeat(4)).as(:date)
      end

      rule(:money_parameter) do
        named_parameter(:money) >>
          space >>
          (match('\d').repeat(1, 4) >> (str('.') >> match('\d').repeat(nil, 2)).maybe).as(:money)
      end

      rule(:category_parameter) do
        named_parameter(:category) >>
          space >>
          quoted_input(:category)
      end

      rule(:comment_parameter) do
        named_parameter(:comment) >>
          space >>
          quoted_input(:comment)
      end

      def parameters_type
        ::Parsers::ParametersFactory.run!(factory_name: kind, style: :const_keeper)
      end

      def value_input_rule_name
        ::Parsers::ValueInputFactory.run!(factory_name: kind, style: :const_keeper)
      end

      private

      def named_parameter(alias_name)
        aliases = named_parameter_aliases(alias_name)
        aliases.map { |value| str(value) }.reduce { |combined, alias_rule| combined | alias_rule }
      end

      def named_parameter_aliases(alias_name)
        alias_value = named_parameters.fetch(alias_name).to_s
        return [alias_value] unless alias_value.start_with?('--')

        [alias_value, alias_value.sub(/\A--/, '—'), alias_value.sub(/\A--/, '–')].uniq
      end

      def named_parameters
        @named_parameters ||= DEFAULT_NAMED_PARAMETER_ALIASES.merge(params.named_parameters.transform_keys(&:to_sym))
      end

      def quoted_input(value_alias)
        (
          str('"') >> match('[^"]').repeat.as(value_alias) >> str('"')
        ) | (
          str("'") >> match("[^']").repeat.as(value_alias) >> str("'")
        )
      end
    end
  end
end

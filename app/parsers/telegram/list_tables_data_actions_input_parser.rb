# frozen_string_literal: true

module Telegram
  class ListTablesDataActionsInputParser < Parslet::Parser
    DEFAULT_PARAMETER_ALIASES = {
      document_id: '--document_id'
    }.freeze

    root(:value_input)

    rule(:value_input) do
      space >> action_number >> space >> document_id_parameter >> space
    end

    rule(:action_number) { match('\d').repeat(1).as(:action_number) >> str(')') }

    rule(:document_id_parameter) do
      named_document_id_parameter | document_id_value
    end

    rule(:named_document_id_parameter) do
      named_parameter(:document_id) >> space >> document_id_value
    end

    rule(:document_id_value) do
      quoted_value(:document_id) | match('[^\s]').repeat(1).as(:document_id)
    end

    rule(:space) { match('\s').repeat }

    def quoted_value(value_alias)
      (
        str('"') >> match('[^"]').repeat(1).as(value_alias) >> str('"')
      ) | (
        str("'") >> match("[^']").repeat(1).as(value_alias) >> str("'")
      )
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
      @named_parameters ||= DEFAULT_PARAMETER_ALIASES
    end
  end
end

# frozen_string_literal: true

module Telegram
  class CommonParser < Parslet::Parser
    root(:value_input)

    rule(:value_input) do
      space >> action_number >> named_parameters.maybe >> space
    end

    rule(:action_number) do
      match('\d').repeat(1).as(:action_number) >> str(')').maybe
    end

    rule(:named_parameters) do
      (space >> named_parameter).repeat(1).as(:named_parameters)
    end

    rule(:named_parameter) do
      parameter_name.as(:key) >> space >> parameter_value
    end

    rule(:parameter_name) do
      (str('--') | str('—') | str('–')) >> match('[a-zA-Z_]').repeat(1)
    end

    rule(:parameter_value) do
      quoted_value | unquoted_value
    end

    rule(:quoted_value) do
      (str('"') >> match('[^"]').repeat(1).as(:value) >> str('"')) |
        (str("'") >> match("[^']").repeat(1).as(:value) >> str("'"))
    end

    rule(:unquoted_value) do
      (named_parameter_start.absent? >> match('[^\s]')).repeat(1).as(:value)
    end

    rule(:space) { match('\s').repeat }

    rule(:named_parameter_start) do
      (str('--') | str('—') | str('–')) >> match('[a-zA-Z_]').repeat(1)
    end

    def parse(text, *args)
      raw_input = super(text, *args)
      parsed_input(raw_input)
    end

    private

    def parsed_input(raw_input)
      result = { action_number: raw_input[:action_number].to_s }
      raw_parameters = Array(raw_input[:named_parameters])

      raw_parameters.each do |parameter|
        result[normalized_key(parameter[:key])] = extract_parameter_value(parameter)
      end

      result
    end

    def normalized_key(raw_key)
      raw_key.to_s.sub(/\A(--|—|–)/, '').tr('-', '_').to_sym
    end

    def extract_parameter_value(parameter)
      parameter[:value].to_s
    end
  end
end

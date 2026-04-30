# frozen_string_literal: true

module Telegram
  class CommandMessageParser < Parslet::Parser
    root(:command_input)

    rule(:command_input) do
      namespace >> command.maybe >> parameter.repeat.as(:parameters) >> space
    end

    rule(:namespace) do
      space.maybe >> str('/').repeat(1, 1) >> match('[a-z_0-9]').repeat(1).as(:namespace)
    end

    rule(:command) do
      required_space >> (str('--') | str('-') | str('—')) >>
        match('[a-z_0-9]').repeat(1).as(:command) >>
        str('=').absent?
    end

    rule(:parameter) do
      named_parameter | flag_parameter
    end

    rule(:flag_parameter) do
      required_space >> (str('--') | str('-') | str('—')) >> match('[a-z_0-9]').repeat(1).as(:name)
    end

    rule(:named_parameter) do
      required_space >> (str('--') | str('-') | str('—')) >>
        match('[a-z_0-9]').repeat(1).as(:name) >>
        str('=') >>
        (double_quoted_string | single_quoted_string)
    end

    rule(:double_quoted_string) do
      str('"') >>
        ((str('\\') >> any | match('[^"\\\\]')).repeat(1) | str('')).as(:value) >>
        str('"')
    end

    rule(:single_quoted_string) do
      str("'") >>
        ((str('\\') >> any | match("[^'\\\\]")).repeat(1) | str('')).as(:value) >>
        str("'")
    end

    rule(:space) { match('\s').repeat }
    rule(:required_space) { match('\s').repeat(1) }
  end
end

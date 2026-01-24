# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module IDefineLayoutFactory
          def define(name, *inline_options, **named_options)
            config[:parsers][name] = yield

            config[:options][name] ||= {}
            config[:options][name][:inline_options] = inline_options
            config[:options][name][:named_options] = named_options
          end

          def config
            @config ||= { parsers: {}, options: {} }
          end
        end

        class InputParsersFactory < ActiveInteraction::Base
          extend IDefineLayoutFactory

          symbol :parser_name

          define(:base) do
            InputParserBase
          end

          def execute
            config[:parsers][parser_name]
          end

          private

          def config
            InputParsersFactory.config
          end
        end
      end
    end
  end
end

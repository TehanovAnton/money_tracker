# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        LAYOUT_INPUT_PARSER = {
          New.name => NewInputParser,
          Index.name => IndexInputParser,
          Delete.name => DeleteInputParser
        }.freeze

        def self.input_parsers(layout)
          LAYOUT_INPUT_PARSER[layout.name]
        end
      end
    end
  end
end

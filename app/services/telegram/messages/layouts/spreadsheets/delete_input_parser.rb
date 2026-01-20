# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class DeleteInputParser < InputParserBase
          private

          def layout_params
            {
              action_number: parsed_input.fetch(:action_number, nil),
              spreadsheet_id: parsed_input.fetch(:spreadsheet_id, nil)
            }.compact
          end
        end
      end
    end
  end
end

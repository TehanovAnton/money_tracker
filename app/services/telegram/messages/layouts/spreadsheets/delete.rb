# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Delete < Base
          string :spreadsheet_id

          def available_actions
            { 0 => { method: :delete_table } }
          end

          private

          def delete_table
            spreadsheet.destroy

            messages << Index.run!(bot: bot, user: user, action_number: 0)
            messages.flatten!
          end

          def spreadsheet
            Spreadsheet.find_by(spreadsheet_id: spreadsheet_id)
          end
        end
      end
    end
  end
end

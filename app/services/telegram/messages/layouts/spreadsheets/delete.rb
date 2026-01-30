# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class Delete < Base
          string :document_id

          define_action(:delete_table)

          private

          def delete_table
            spreadsheet.destroy

            messages << layouts_factory(layout_name: :index)
                        .run!(bot: bot, user: user, action_name: :list_all_actions)
            messages.flatten!
          end

          def spreadsheet
            Spreadsheet.find_by(document_id: document_id)
          end
        end
      end
    end
  end
end

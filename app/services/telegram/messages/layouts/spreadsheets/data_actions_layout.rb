# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class DataActionsLayout < Base
          string :document_id, default: nil

          define_action(:list_all_actions, 'Доступные действия')
          define_action(:add_expense, 'Добавить расход')

          private

          def add_expense
            return messages << 'Пустой id таблицы' unless document_id

            chat_context
            messages << layouts_factory(layout_name: :add_expense)
                        .run!(bot: bot, user: user, document_id: document_id)
            messages.flatten!
          end

          def chat_context
            ChatContext.create!(user: user, spreadsheet_id: Spreadsheet.find_by(document_id: document_id))
          end
        end
      end
    end
  end
end

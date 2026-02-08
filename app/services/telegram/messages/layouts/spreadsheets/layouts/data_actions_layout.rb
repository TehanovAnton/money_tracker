# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Layouts
          module IDataActionsLayoutLayouts
            def add_expense_layout
              layouts_factory(layout_name: :add_expense)
            end
          end

          class DataActionsLayout < Base
            include IDataActionsLayoutLayouts

            string :document_id, default: nil

            define_action(:list_all_actions, 'Доступные действия')
            define_action(:add_expense, 'Добавить расход')

            private

            def add_expense
              return messages << 'Пустой id таблицы' unless spreadsheet_id

              handle_messages do
                add_expense_layout.run!(
                  bot: bot,
                  user: user,
                  spreadsheet_id: spreadsheet_id,
                  action_name: :list_all_actions
                )
              end
            end

            def spreadsheet_id
              Spreadsheet.where(id: chat_context.spreadsheet_id).select(:id).last.id
            end

            def chat_context
              @chat_context ||= ChatContext.find_by(user_id: user.id)
            end
          end
        end
      end
    end
  end
end

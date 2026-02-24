# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Layouts
          module IDataActionsLayoutLayouts
            def add_expense_layout(expense_data_input: :field_by_field)
              case expense_data_input
              when :field_by_field
                layouts_factory(layout_name: :add_expense)
              else
                raise ArgumentError, "Unknown expense_data_input: #{expense_data_input}"
              end
            end
          end

          class DataActionsLayout < Base
            include IDataActionsLayoutLayouts

            string :document_id, default: nil
            symbol :expense_data_input, default: :field_by_field

            define_action(:list_all_actions, 'Доступные действия')
            define_action(:add_expense, 'Добавить расход')
            define_action(:back, 'Назад')

            private

            def add_expense
              return messages << 'Пустой id таблицы' unless spreadsheet_id

              handle_messages do
                add_expense_layout(expense_data_input: expense_data_input).run!(
                  bot: bot,
                  user: user,
                  spreadsheet_id: spreadsheet_id,
                  action_name: :list_all_actions
                )
              end
            end

            def back
              handle_messages { list_tables_layout.run!(bot: bot, user: user, action_name: :list_all_actions) }
            end

            def list_tables_layout
              layouts_factory(layout_name: :list_tables)
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

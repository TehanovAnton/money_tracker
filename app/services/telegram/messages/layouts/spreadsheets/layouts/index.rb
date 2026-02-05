# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Layouts
          class Index < Base
            define_action(:list_all_actions, 'Доступные действия')
            define_action(:list_tables, 'Мои таблицы')
            define_action(:add_table, 'Добавить таблицу')

            private

            def list_tables
              messages << layouts_factory(layout_name: :list_tables)
                          .run!(bot: bot, user: user, action_name: :list_tables)
              messages.flatten!
            end

            def add_table
              messages << layouts_factory(layout_name: :new)
                          .run!(bot: bot, user: user, action_name: :enter_document_id)
              messages.flatten!
            end
          end
        end
      end
    end
  end
end

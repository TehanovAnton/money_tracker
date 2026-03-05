# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class Index < Base
      define_action(:list_all_actions, 'Доступные действия')
      define_action(:list_tables, 'Мои таблицы')
      define_action(:add_table, 'Добавить таблицу')
      define_action(:back, 'Назад')

      private

      def list_tables
        handle_messages { list_tables_layout.run!(bot: bot, user: user, action_name: :list_tables) }
      end

      def add_table
        handle_messages { new_layout.run!(bot: bot, user: user, action_name: :list_all_actions) }
      end

      def back
        handle_messages { index_layout.run!(bot: bot, user: user, action_name: :list_all_actions) }
      end

      def new_layout
        layouts_factory(layout_name: :new)
      end

      def index_layout
        layouts_factory(layout_name: :index)
      end

      def list_tables_layout
        layouts_factory(layout_name: :list_tables)
      end
    end
  end
end

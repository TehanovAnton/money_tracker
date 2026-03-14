# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class LayoutsFactory < BaseFactory
      define(:index) do
        IndexService
      end

      define(:new) do
        NewService
      end

      define(:delete) do
        DeleteService
      end

      define(:list_tables) do
        ListTablesService
      end

      define(:data_actions) do
        DataActionsLayoutService
      end

      define(:add_expense) do
        AddExpenseLayoutService
      end
    end
  end
end

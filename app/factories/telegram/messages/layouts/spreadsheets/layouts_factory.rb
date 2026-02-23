# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class LayoutsFactory < BaseFactory
          define(:index) do
            Layouts::Index
          end

          define(:new) do
            Layouts::New
          end

          define(:delete) do
            Layouts::Delete
          end

          define(:list_tables) do
            Layouts::ListTables
          end

          define(:data_actions) do
            Layouts::DataActionsLayout
          end

          define(:add_expense) do
            Layouts::AddExpenseLayout
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class LayoutsFactory < BaseFactory
          define(:index) do
            Index
          end

          define(:new) do
            New
          end

          define(:delete) do
            Delete
          end

          define(:list_tables) do
            ListTables
          end
        end
      end
    end
  end
end

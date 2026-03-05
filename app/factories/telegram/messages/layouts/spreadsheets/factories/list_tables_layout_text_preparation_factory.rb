# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class ListTablesLayoutTextPreparationFactory < BaseFactory
            multi_define(
              :list_all_actions,
              :list_tables,
              :edit_table,
              :back_to_index
            ) do
              Support::ActionNumberTextPreparation
            end

            multi_define(
              :data_actions,
              :delete_table,
              data_actions: { named_options: { clean_white_space: true } },
              delete_table: { named_options: { clean_white_space: true } }
            ) do
              Support::TextPreparation
            end
          end
        end
      end
    end
  end
end

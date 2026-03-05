# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class DefaultLayoutParamsFactory < BaseFactory
            multi_define(
              :action_number,
              :value_input
            ) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::DefaultLayoutParamsBuilder
            end
          end
        end
      end
    end
  end
end

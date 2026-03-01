# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class AddExpenseLayoutParamsFactory < BaseFactory
            define(:list_all_actions) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::DefaultLayoutParamsBuilder
            end

            define(:back_to_index) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::DefaultLayoutParamsBuilder
            end

            define(:action_input, [{ name: :action_number }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:value_input, [{ name: :action_number }, { name: :document_id }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_date, [{ name: :action_number }, { name: :date }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_range, [{ name: :action_number }, { name: :range }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_money, [{ name: :action_number }, { name: :money }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_category, [{ name: :action_number }, { name: :category }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_comment, [{ name: :action_number }, { name: :comment }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:enter_all,
                   [{ name: :action_number }, { name: :date }, { name: :money }, { name: :category },
                    { name: :comment }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:publish_expense, [{ name: :action_number }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end
          end
        end
      end
    end
  end
end

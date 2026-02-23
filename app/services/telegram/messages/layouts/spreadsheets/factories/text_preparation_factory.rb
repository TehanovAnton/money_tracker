# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class TextPreparationFactory < BaseFactory
            define(:enter_date, clean_white_space: true) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end

            define(:enter_range, clean_white_space: true) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end

            define(:enter_money, clean_white_space: true) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end

            define(:enter_category, clean_white_space: false) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end

            define(:enter_comment, clean_white_space: false) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end

            define(:publish_expense, clean_white_space: true) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Support
          class TextPreparationFactory < BaseFactory
            define(:enter_date, clean_white_space: true) do
              TextPreparation
            end

            define(:enter_money, clean_white_space: true) do
              TextPreparation
            end

            define(:enter_category, clean_white_space: false) do
              TextPreparation
            end

            define(:enter_comment, clean_white_space: false) do
              TextPreparation
            end
          end
        end
      end
    end
  end
end

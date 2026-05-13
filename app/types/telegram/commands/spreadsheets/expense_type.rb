# frozen_string_literal: true

require 'dry/types'

module Telegram
  module Commands
    module Spreadsheets
      class ExpenseType < Dry::Struct
        attribute :date, DateType
        attribute :amount, AmountType
        attribute :category, CategoryType
        attribute? :comment, Types::String.optional
      end
    end
  end
end

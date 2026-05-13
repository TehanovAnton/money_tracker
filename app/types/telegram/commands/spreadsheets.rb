# frozen_string_literal: true

require 'dry/types'

module Telegram
  module Commands
    module Spreadsheets
      AmountType = Types::Strict::String.constrained(format: /\A-?\d+(\.\d{1,2})?\z/)
      DocumentIdType = Types::String.constrained(filled: true)
      RangeType = Types::String.constrained(filled: true)
      DateType = Types::String.constrained(filled: true)
      CategoryType = Types::String.constrained(filled: true)
      CommentType = Types::String.optional

      RowType = Types::Nominal::Array.constructor do |row|
        [
          DateType[row[0]],
          AmountType[row[1]],
          CategoryType[row[2]],
          CommentType[row[3]]
        ]
      end

      ValuesType = Types::Array.of(RowType)

      CATEGORIES = %w[
        Продукты
        Транспорт
      ].freeze

      CategoryType = Types::String.enum(*CATEGORIES)

      class SheetPayloadType < Dry::Struct
        attribute :range, RangeType
        attribute :values, ValuesType
      end

      class PayloadType < Dry::Struct
        attribute :document_id, DocumentIdType
        attribute :sheet, SheetPayloadType
      end
    end
  end
end

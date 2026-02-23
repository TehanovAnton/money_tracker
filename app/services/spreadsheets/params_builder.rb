# frozen_string_literal: true

require 'dry/types'

module Spreadsheets
  class ParamsBuilder < ActiveInteraction::Base
    module Types
      include Dry.Types()
    end

    class NoValueError < StandardError; end

    DocumentIdType = Types::String.constrained(filled: true)
    RangeType = Types::String.constrained(filled: true)
    DateType = Types::String.constrained(filled: true)
    MoneyType = Types::Decimal
    CategoryType = Types::String.constrained(filled: true)
    CommentType = Types::String.optional
    RowType = Types::Nominal::Array.constructor do |row|
      normalized_row = row.to_a
      raise Dry::Types::ConstraintError, normalized_row unless normalized_row.size == 4

      [
        DateType[normalized_row[0]],
        MoneyType[normalized_row[1]],
        CategoryType[normalized_row[2]],
        CommentType[normalized_row[3]]
      ]
    end
    ValuesType = Types::Array.of(RowType)

    class SheetPayload
      attr_reader :range, :values

      def initialize(range:, values:)
        @range = range
        @values = values
      end

      def to_h
        { range: range, values: values }
      end
    end

    class Payload
      attr_reader :document_id, :sheet

      def initialize(document_id:, sheet:)
        @document_id = document_id
        @sheet = sheet
      end

      def to_h
        { document_id: document_id, sheet: sheet.to_h }
      end
    end

    object :spreadsheet_form, class: SpreadsheetForm

    def execute
      Payload.new(
        document_id: DocumentIdType[document_id],
        sheet: SheetPayload.new(
          range: RangeType[range],
          values: ValuesType[values]
        )
      )
    end

    private

    def document_id
      spreadsheet_form.spreadsheet.document_id
    end

    def range
      get_input(type: 'RangeFormInput', attribute: :range, input_type: RangeType)
    end

    def values
      [
        [
          get_input(type: 'DateFormInput', attribute: :date, input_type: DateType),
          get_input(type: 'MoneyFormInput', attribute: :money, input_type: MoneyType),
          get_input(type: 'CategoryFormInput', attribute: :category, input_type: CategoryType),
          get_input(type: 'CommentFormInput', attribute: :comment, input_type: CommentType)
        ]
      ]
    end

    def get_input(type:, attribute:, input_type:)
      input_value = spreadsheet_form.inputs.find_by(type: type)&.public_send(attribute)

      input_type[input_value]
    rescue Dry::Types::ConstraintError, Dry::Types::CoercionError
      raise NoValueError, "form_id: #{spreadsheet_form.id}, #{type}"
    end
  end
end

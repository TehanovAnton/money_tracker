# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class UpsertExpenseService < ActiveInteraction::Base
        ValueRange = ::Google::Apis::SheetsV4::ValueRange
        SheetsService = ::Google::Apis::SheetsV4::SheetsService
        ServiceAccountCredentials = Google::Auth::ServiceAccountCredentials

        record :spreadsheet
        object :expense, class: ExpenseType

        def execute
          spreadsheets.append_spreadsheet_value(
            document_id,
            range,
            values,
            value_input_option: 'USER_ENTERED'
          )
        rescue Google::Apis::Error => e
          errors.add(:base, e.message)
        end

        private

        def params
          @params ||= PayloadType.new(
            document_id: document_id,
            sheet: sheet_payload
          )
        end

        def sheet_payload
          SheetPayloadType.new(
            range: range,
            values: [
              [expense.date, expense.amount, expense.category, expense.comment]
            ]
          )
        end

        def range
          spreadsheet.expense_range
        end

        def document_id
          spreadsheet.document_id
        end

        def values
          ValueRange.new(values: params.sheet.values)
        end

        def spreadsheets
          @spreadsheets ||= SheetsService.new.tap do |service|
            service.authorization = authorizer
          end
        end

        def authorizer
          authorizer = ServiceAccountCredentials.make_creds(
            json_key_io: service_account_json,
            scope: scope
          )
          authorizer.tap(&:fetch_access_token!)
        end

        def service_account_json
          StringIO.new(Settings.dig(*%i[app google drive service_accounts test_account]).to_json)
        end

        def scope
          'https://www.googleapis.com/auth/spreadsheets'
        end
      end
    end
  end
end

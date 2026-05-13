# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class DocumentRestBalanceService < BaseService
        ValueRange = ::Google::Apis::SheetsV4::ValueRange
        SheetsService = ::Google::Apis::SheetsV4::SheetsService
        ServiceAccountCredentials = Google::Auth::ServiceAccountCredentials

        string :document_id
        string :cell

        def execute
          return unless cell_value

          cell_value
        end

        private

        def cell_value
          @cell_value ||= spreadsheets.get_spreadsheet_values(document_id, cell).values.flatten.first
        rescue StandardError => e
          Rails.logger.warn(e.message)
          errors.add(:base, 'Something went wrong')
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

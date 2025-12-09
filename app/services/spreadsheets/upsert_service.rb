# frozen_string_literal: true

module Spreadsheets
  class UpsertService < ActiveInteraction::Base
    hash :params, strip: false

    def execute
      spreadsheets.append_spreadsheet_value(
        spreadsheet_id,
        params[:sheet][:range],
        values_object,
        value_input_option: 'USER_ENTERED'
      )
    end

    private

    def spreadsheet_id
      params[:spreadsheet_id]
    end

    def values_object
      ::Google::Apis::SheetsV4::ValueRange.new(values: params[:sheet][:values])
    end

    def spreadsheets
      @spreadsheets ||= ::Google::Apis::SheetsV4::SheetsService.new.tap do |service|
        service.authorization = authorizer
      end
    end

    def authorizer
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
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

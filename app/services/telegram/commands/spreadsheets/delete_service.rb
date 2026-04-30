# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class DeleteService < BaseService
        record :user
        string :document_id, default: nil

        def execute
          return render_view(:not_found) if spreadsheet.blank?

          spreadsheet.destroy
          render_view(:success, document_id: document_id)
        end

        private

        def spreadsheet
          @spreadsheet ||= Spreadsheet.find_by(document_id: document_id, user_id: user.id)
        end

        def template(view)
          "telegram/commands/spreadsheets/delete/#{view}"
        end
      end
    end
  end
end

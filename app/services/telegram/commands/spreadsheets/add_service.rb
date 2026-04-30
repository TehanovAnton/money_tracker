# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class AddService < BaseService
        record :user
        string :document_id
        string :expense_range

        validate :check_document_id
        validate :check_expense_range

        def execute
          return render_view(:invalid_record, spreadsheet: spreadsheet) unless spreadsheet.valid?

          render_view(:success, spreadsheet: spreadsheet)
        end

        private

        def check_document_id
          return if document_id.present?

          errors.add(:document_id, 'Must ti be present')
        end

        def check_expense_range
          return if expense_range.present?

          errors.add(:expense_range, 'Must ti be present')
        end

        def spreadsheet
          @spreadsheet ||= Spreadsheet.create(user: user, document_id: document_id, expense_range: expense_range)
        end

        def template(view)
          "telegram/commands/spreadsheets/add/#{view}"
        end
      end
    end
  end
end

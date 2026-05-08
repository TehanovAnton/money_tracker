# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class AddExpenseService < BaseService
        record :user
        string :document_id
        object :expense_data, class: ExpenseType
        object :upsert_expense_service, default: UpsertExpenseService, class: UpsertExpenseService.class.name

        def execute
          return render_view(:could_not_find_spreadsheet, document_id: document_id) unless spreadsheet
          return render_view(:invalid_record, expense: expense) unless expense.valid?

          publish_expesnse
          render_view(:success, expense: expense)
        end

        private

        def publish_expesnse
          upsert_expense_service.run!(spreadsheet: spreadsheet, expense: expense_data)
        end

        def expense
          @expense ||= spreadsheet.expenses.create(
            **expense_data
          )
        end

        def spreadsheet
          @spreadsheet ||= Spreadsheet.find_by(document_id: document_id, user_id: user.id)
        end

        def template(view)
          "telegram/commands/spreadsheets/add_expense/#{view}"
        end
      end
    end
  end
end

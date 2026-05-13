# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class RestBalanceService < BaseService
        FLAGS = { compare: 'compare', show: 'show' }.freeze

        record :user
        string :document_id
        string :flag, default: FLAGS[:show]
        string :expected_balance, class: AmountType, default: nil
        object :document_rest_balance_service, class: 'Class', default: DocumentRestBalanceService

        validate :validate_document_rest_balance_service

        def execute
          # Сделай модульно, эта проверка нужна во всех командах. Сделай дефолтной с возможностью отключить
          # или переопределить
          return render_view(:could_not_find_spreadsheet, document_id: document_id) unless spreadsheet
          return render_view(:fill_rest_balance_cell) unless spreadsheet.rest_balance_cell
          return render_view(:fail) unless rest_balance

          flag_registry[flag].call
        end

        private

        def flag_registry
          @flag_registry ||= {
            'compare' => method(:compare_command),
            'show' => method(:show_command)
          }
        end

        def compare_command
          render_view(:compare, rest_balance: rest_balance, expected_balance: expected_balance)
        end

        def show_command
          render_view(:success, rest_balance: rest_balance)
        end

        def spreadsheet
          @spreadsheet ||= Spreadsheet.find_by(document_id: document_id, user_id: user.id)
        end

        def rest_balance
          @rest_balance ||= document_rest_balance_service.run!(
            document_id: document_id, cell: spreadsheet.rest_balance_cell
          )
        end

        def template(view)
          "telegram/commands/spreadsheets/rest_balance/#{view}"
        end

        def validate_document_rest_balance_service
          return if document_rest_balance_service <= DocumentRestBalanceService

          errors.add(:document_rest_balance_service, 'Must be DocumentRestBalanceService or subclass')
        end
      end
    end
  end
end

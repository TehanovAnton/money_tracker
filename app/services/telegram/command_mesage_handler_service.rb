# frozen_string_literal: true

module Telegram
  class CommandMesageHandlerService < ActiveInteraction::Base
    record :user
    string :message_text

    def execute
      commands_registry[command_params.command].call
    rescue ActiveInteraction::InvalidInteractionError, StandardError => e
      Rails.logger.debug e
      render_view(:fail)
    end

    private

    def commands_registry
      @commands_registry ||= {
        list_all: method(:list_all_command),
        add: method(:add_command),
        delete: method(:delete_command),
        add_expense: method(:add_expense_command),
        rest_balance: method(:rest_balance_command)
      }
    end

    def list_all_command
      Commands::Spreadsheets::ListAllService.run!(user: user)
    end

    def add_command
      interaction = Commands::Spreadsheets::AddService.run(
        user: user,
        document_id: command_params.document_id,
        expense_range: command_params.expense_range
      )

      return Commands::Spreadsheets::Add::RenderService.run!(view: :fail) unless interaction.valid?

      interaction.result
    end

    def delete_command
      Commands::Spreadsheets::DeleteService.run!(
        user: user, document_id: command_params.document_id
      )
    end

    def add_expense_command
      Commands::Spreadsheets::AddExpenseService.run!(
        user: user,
        document_id: command_params.document_id,
        show_rest_balance: command_params.show_rest_balance,
        expense_data: Commands::Spreadsheets::ExpenseType.new(
          date: command_params.date,
          amount: command_params.amount,
          category: command_params.category,
          comment: command_params.comment
        )
      )
    end

    def rest_balance_command
      Commands::Spreadsheets::RestBalanceService.run!(
        user: user,
        document_id: command_params.document_id,
        expected_balance: command_params.expected_balance,
        flag: command_params.flag
      )
    end

    def command_params
      CommandMessageParserService.run!(text: message_text)
    end

    def render_view(view, **locals)
      Commands::Spreadsheets::RenderService.run!(
        template: template(view),
        formats: [:text],
        locals: locals
      )
    end

    def template(view)
      "telegram/commands/spreadsheets/#{view}"
    end
  end
end

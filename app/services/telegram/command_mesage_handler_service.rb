# frozen_string_literal: true

module Telegram
  class CommandMesageHandlerService < ActiveInteraction::Base
    record :user
    string :message_text

    def execute
      commands_registry[command_params.name].call
    end

    private

    def commands_registry
      @commands_registry ||= {
        list_all: method(:list_all_command),
        add: method(:add_command),
        delete: method(:delete_command)
      }
    end

    def list_all_command
      Commands::Spreadsheets::ListAllService.run!(user: user)
    end

    def add_command
      interaction = Commands::Spreadsheets::AddService.run(
        user: user, document_id: command_params.document_id, expense_range: command_params.expense_range
      )
      return Commands::Spreadsheets::Add::RenderService.run!(view: :fail) unless interaction.valid?

      interaction.result
    end

    def delete_command
      Commands::Spreadsheets::DeleteService.run!(
        user: user, document_id: command_params.document_id
      )
    end

    def command_params
      CommandMessageParserService.run!(text: message_text)
    end
  end
end

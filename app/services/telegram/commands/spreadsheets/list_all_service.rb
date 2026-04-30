# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class ListAllService < BaseService
        record :user

        def execute
          render_view(:index, spreadsheets: spreadsheets)
        end

        private

        def template(view)
          "telegram/commands/spreadsheets/list_all/#{view}"
        end

        def spreadsheets
          @spreadsheets ||= Spreadsheet.where(user: user).order(:id).to_a
        end
      end
    end
  end
end

# frozen_string_literal: true

module Telegram
  module AddExpenseInputParser
    class BaseParser < ::Parslet::Parser
      module Types
        include Dry.Types()
      end
    end
  end
end

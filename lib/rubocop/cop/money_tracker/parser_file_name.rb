# frozen_string_literal: true

module RuboCop
  module Cop
    module MoneyTracker
      class ParserFileName < FileNameBase
        TARGET_FOLDER = 'parsers'
        TARGET_SINGULAR = 'parser'
      end
    end
  end
end

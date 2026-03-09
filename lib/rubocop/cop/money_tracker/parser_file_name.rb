# frozen_string_literal: true

require_relative 'file_name_base'

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

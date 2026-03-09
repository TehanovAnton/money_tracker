# frozen_string_literal: true

require_relative 'folder_naming_base'

module RuboCop
  module Cop
    module MoneyTracker
      class ParsersFolderNaming < FolderNamingBase
        TARGET_FOLDER = 'parsers'
        TARGET_SINGULAR = 'parser'
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'folder_naming_base'

module RuboCop
  module Cop
    module MoneyTracker
      class FactoriesFolderNaming < FolderNamingBase
        TARGET_FOLDER = 'factories'
        TARGET_SINGULAR = 'factory'
      end
    end
  end
end

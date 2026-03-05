# frozen_string_literal: true

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

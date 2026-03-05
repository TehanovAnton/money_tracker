# frozen_string_literal: true

module RuboCop
  module Cop
    module MoneyTracker
      class DecoratorsFolderNaming < FolderNamingBase
        TARGET_FOLDER = 'decorators'
        TARGET_SINGULAR = 'decorator'
      end
    end
  end
end

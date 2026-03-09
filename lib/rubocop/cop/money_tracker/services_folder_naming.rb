# frozen_string_literal: true

require_relative 'folder_naming_base'

module RuboCop
  module Cop
    module MoneyTracker
      class ServicesFolderNaming < FolderNamingBase
        TARGET_FOLDER = 'services'
        TARGET_SINGULAR = 'service'
      end
    end
  end
end

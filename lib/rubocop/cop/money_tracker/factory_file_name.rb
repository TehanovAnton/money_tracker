# frozen_string_literal: true

require_relative 'file_name_base'

module RuboCop
  module Cop
    module MoneyTracker
      class FactoryFileName < FileNameBase
        TARGET_FOLDER = 'factories'
        TARGET_SINGULAR = 'factory'
      end
    end
  end
end

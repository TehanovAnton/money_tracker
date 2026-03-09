# frozen_string_literal: true

require_relative 'file_name_base'

module RuboCop
  module Cop
    module MoneyTracker
      class DecoratorFileName < FileNameBase
        TARGET_FOLDER = 'decorators'
        TARGET_SINGULAR = 'decorator'
      end
    end
  end
end

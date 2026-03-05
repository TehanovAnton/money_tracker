# frozen_string_literal: true

require_relative 'naming_base'

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

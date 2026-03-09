# frozen_string_literal: true

require_relative 'file_name_base'

module RuboCop
  module Cop
    module MoneyTracker
      class ServiceFileName < FileNameBase
        TARGET_FOLDER = 'services'
        TARGET_SINGULAR = 'service'
      end
    end
  end
end

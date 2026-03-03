# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Builders
          class DefaultLayoutParamsBuilder
            attr_reader :params, :layout_params

            def initialize(params: {})
              @params = params
              @layout_params = {}
            end

            def build
              params.each { |key, value| layout_params[key.to_sym] = value }
              self
            end
          end
        end
      end
    end
  end
end

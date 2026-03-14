# frozen_string_literal: true

module Telegram
  module MessageLayouts
    module Builders
      class LayoutParamsBuilder
        attr_reader :with_layout_params, :layout_params, :params

        def initialize(with_layout_params, params: {})
          @with_layout_params = with_layout_params
          @layout_params = {}
          @params = params
        end

        def build
          with_layout_params.each { |layout_param| add_layout_param(layout_param) }
          self
        end

        private

        def add_layout_param(layout_param)
          layout_params[layout_param[:name]] = params.fetch(
            layout_param[:name],
            layout_param[:default_value] || nil
          )
        end
      end
    end
  end
end

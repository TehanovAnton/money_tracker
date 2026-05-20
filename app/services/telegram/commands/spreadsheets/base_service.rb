# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class BaseService < ApplicationInteraction
        private

        def render_view(view, **locals)
          RenderService.run!(
            template: template(view),
            formats: formats,
            locals: locals
          )
        end

        def template(view)
          raise NotImplementedError
        end

        def formats
          [:text]
        end
      end
    end
  end
end

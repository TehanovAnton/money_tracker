# frozen_string_literal: true

module Telegram
  module Commands
    module Spreadsheets
      class RenderService < ApplicationInteraction
        array :formats, default: []
        hash :locals, strip: false, default: {}
        string :template, default: nil

        def execute
          ApplicationController.render(
            template: template,
            formats: formats,
            locals: locals
          ).strip
        end
      end
    end
  end
end

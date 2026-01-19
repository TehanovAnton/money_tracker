# frozen_string_literal: true

module ParserHelper
  extend ActiveSupport::Concern

  included do
    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
  end
end

# frozen_string_literal: true

class ActionParser < Parslet::Parser
  root(:expression)
  rule(:expression) { keyword >> value }

  rule(:keyword) { str('action').repeat(1).as(:keyword) >> colon }
  rule(:value) { match('[a-z]').repeat(1, nil).as(:value) >> semicolon }

  rule(:colon) { str(':').repeat(1) >> space? }
  rule(:semicolon) { str(';').repeat(1) }

  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
end

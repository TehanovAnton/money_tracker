# frozen_string_literal: true

class MethodParser < Parslet::Parser
  root(:expression)
  rule(:expression) { keyword >> value }

  rule(:keyword) { str('method').repeat(1).as(:keyword) >> colon }
  rule(:value) { (str('get') | str('post')).repeat(1).as(:value) >> semicolon }

  rule(:colon) { str(':').repeat(1) >> space? }
  rule(:semicolon) { str(';').repeat(1) }

  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
end

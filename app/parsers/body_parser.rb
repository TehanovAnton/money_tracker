# frozen_string_literal: true

class BodyParser < Parslet::Parser
  root(:expression)
  rule(:expression) { keyword >> value }

  rule(:keyword) { exact('body') >> exact(':') >> space? }
  rule(:value) { value_literal >> semicolon }

  rule(:value_literal) do
    spreadsheet_id >> space? >>
      sheet_range >> space? >>
      exact('[') >>
      date >>
      money >>
      category >>
      (exact(']') | (exact(';') >> space? >> comment >> exact(']')))
  end

  rule(:spreadsheet_id) do
    exact('spreadsheet_id') >> exact(':') >> space? >> match(/[^\s;]/).repeat.as(:spreadsheet_id) >> exact(';')
  end

  rule(:sheet_range) do
    exact('sheet_range') >> exact(':') >> space? >> match(/[^\s;]/).repeat.as(:sheet_range) >> exact(';')
  end

  rule(:date) do
    (
      match(/\d/).repeat(2) >> exact('.') >>
      match(/\d/).repeat(2) >> exact('.') >>
      match(/\d/).repeat(4)
    ).as(:date) >>
      exact(';')
  end

  rule(:money) do
    space? >> (
      match(/\d/).repeat >> exact(',') >>
      match(/\d/).repeat(1, 2)
    ).as(:money) >>
      exact(';')
  end

  rule(:category) do
    space? >> match(/[а-яА-Я]/).repeat.as(:category)
  end

  rule(:comment) { match(/[^\]]/).repeat.as(:comment) }

  rule(:colon) { str(':').repeat(1) >> space? }
  rule(:semicolon) { str(';').repeat(1) }

  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  def exact(text_sym)
    str(text_sym).repeat(1)
  end
end

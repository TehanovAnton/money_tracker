# frozen_string_literal: true

module TelegramBot
  class BodyParser < Parslet::Parser
    root(:expression)
    rule(:expression) { keyword >> value }

    rule(:keyword) { str('body').repeat(1).as(:keyword) >> colon >> space? }
    rule(:value) { value_literal >> semicolon }

    rule(:value_literal) do
      exact('[') >>
        date >>
        money >>
        category >>
        exact(']')
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

    rule(:colon) { str(':').repeat(1) >> space? }
    rule(:semicolon) { str(';').repeat(1) }

    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }

    def exact(text_sym)
      str(text_sym).repeat(1)
    end
  end
end

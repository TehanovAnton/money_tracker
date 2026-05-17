# frozen_string_literal: true

module Telegram
  class CommandMessageParserService < ActiveInteraction::Base
    string :text

    def execute
      parsed = CommandMessageParser.new.parse(text).to_h

      params = Array(parsed[:parameters]).each_with_object({}) do |param, hash|
        param_name = param[:name].to_s.to_sym
        next hash[param_name] = true if param[:value].nil?

        hash[param_name] = param[:value].to_s
      end

      OpenStruct.new(command: parsed.fetch(:command).to_s.to_sym, **params)
    end
  end
end

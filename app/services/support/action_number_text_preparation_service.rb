# frozen_string_literal: true

module Support
  ActionNumberTextPreparationService = Struct.new(:text) do
    def prepared_text
      text.to_s.split(')').first.to_s.gsub(/\s/, '')
    end
  end
end

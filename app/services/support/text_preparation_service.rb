# frozen_string_literal: true

module Support
  TextPreparationService = Struct.new(:text, :clean_white_space) do
    def prepared_text
      return text unless clean_white_space

      text.gsub(/\s/, '')
    end
  end
end

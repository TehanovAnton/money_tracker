# frozen_string_literal: true

require 'dry/types'

module Telegram
  module Commands
    module Spreadsheets
      DATE_FORMATS = ['%d.%m.%Y', '%d-%m-%Y'].freeze

      DateType = Types::String.constructor do |value|
        next value if check_formats(value)

        raise Dry::Types::CoercionError,
              "#{value.inspect} is not a valid date string. Must be in one of formats: #{DATE_FORMATS.inspect}"
      end

      def check_formats(value)
        DATE_FORMATS.each do |format|
          return true if Date.strptime(value, format)
        rescue Date::Error
          # skip
        end

        false
      end
    end
  end
end

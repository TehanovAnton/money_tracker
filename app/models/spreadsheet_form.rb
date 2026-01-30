# frozen_string_literal: true

class SpreadsheetForm < ApplicationRecord
  belongs_to :user
  belongs_to :spreadsheet
  has_many :inputs, class_name: 'FormInput' # rubocop:disable Rails/HasManyOrHasOneDependent
end

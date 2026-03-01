# frozen_string_literal: true

class Spreadsheet < ApplicationRecord
  belongs_to :user

  validates :document_id, presence: true
  validates :expense_range, presence: true
end

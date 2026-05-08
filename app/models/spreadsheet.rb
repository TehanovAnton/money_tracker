# frozen_string_literal: true

class Spreadsheet < ApplicationRecord
  belongs_to :user

  has_many :expenses

  validates :document_id, presence: true
  validates :expense_range, presence: true
end

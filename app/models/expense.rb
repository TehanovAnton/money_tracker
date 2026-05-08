# frozen_string_literal: true

class Expense < ApplicationRecord
  belongs_to :spreadsheet

  validates :amount, numericality: { greater_than: 0 }
end

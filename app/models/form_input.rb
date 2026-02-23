# frozen_string_literal: true

class FormInput < ApplicationRecord
  belongs_to :spreadsheet_form, foreign_key: :form_id, inverse_of: :inputs
end

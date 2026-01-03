# frozen_string_literal: true

class MessageBodyDecorator < SimpleDelegator
  def spreadsheet_id
    __getobj__[:spreadsheet_id].to_s
  end

  def sheet_range
    __getobj__[:sheet_range].to_s
  end

  def date
    __getobj__[:date].to_s
  end

  def money
    __getobj__[:category].to_s
  end

  def comment
    __getobj__[:comment].to_s
  end

  def category
    __getobj__[:comment].to_s
  end
end

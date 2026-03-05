# frozen_string_literal: true

require_relative 'factory_bot'
require 'webmock/rspec'
require 'telegram/bot'
require 'fileutils'
require 'tmpdir'
require 'rubocop'
require 'rubocop/rspec/support'

# Load all support dir
Dir['./spec/support/**/*.rb'].each { |file| require file }

Dir[File.expand_path('../../lib/rubocop/cop/money_tracker/**/*.rb', __dir__)].sort.each do |file|
  require file
end

TelegramSpreadsheets = Telegram::MessageLayouts
IndexService = TelegramSpreadsheets::IndexService
NewService = TelegramSpreadsheets::NewService
DeleteService = TelegramSpreadsheets::DeleteService
ListTablesService = TelegramSpreadsheets::ListTablesService
DataActionsLayoutService = TelegramSpreadsheets::DataActionsLayoutService
AddExpenseLayoutService = TelegramSpreadsheets::AddExpenseLayoutService
Index = IndexService
New = NewService
Delete = DeleteService
ListTables = ListTablesService
DataActionsLayout = DataActionsLayoutService
AddExpenseLayout = AddExpenseLayoutService

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  Rails.logger = Logger.new($stdout)
  Rails.logger.level = Logger::UNKNOWN
end

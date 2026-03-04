# frozen_string_literal: true

require 'rubocop'
require 'rubocop/rspec/support'
require_relative '../../../../lib/rubocop/cop/money_tracker/decorator_file_name'

describe RuboCop::Cop::MoneyTracker::DecoratorFileName, :config do
  include CopHelper

  subject(:offenses) { inspect_source(source, file_path) }

  let(:source) { 'class Example; end' }

  context 'when file is inside app/decorators and has invalid suffix' do
    let(:file_path) { 'app/decorators/telegram/bot_decorators/base.rb' }

    it 'registers an offense' do
      expect(offenses.size).to eq(1)
    end
  end

  context 'when file is inside app/decorators and has valid suffix' do
    let(:file_path) { 'app/decorators/telegram/bot_decorators/base_decorator.rb' }

    it 'does not register offenses' do
      expect(offenses).to be_empty
    end
  end

  context 'when file is outside app/decorators and has invalid suffix' do
    let(:file_path) { 'app/services/base.rb' }

    it 'does not register offenses' do
      expect(offenses).to be_empty
    end
  end
end

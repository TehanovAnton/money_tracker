# frozen_string_literal: true

require 'rails_helper'

describe Telegram::MessageHandler do
  subject { described_class.run(bot: bot) }

  let(:bot) { Telegram::BotDecorator.new({}, nil) }
  let(:user) { FactoryBot.create(:user) }
  let(:message_text) { '1' }

  before do
    allow(bot).to receive(:send_message)
    allow(bot).to receive_messages(
      username: user.telegram_username,
      message_text: message_text
    )
  end

  context 'when /start' do
    let(:message_text) { '/start' }

    it do
      expect(subject).to be_valid

      user.reload
      expect(user.layout_cursor_action.layout).to eq(Index.name)
    end
  end

  context 'when layout_cursor_action exists' do
    let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
    let(:layout_cursor_action) { user.layout_cursor_action }
    let(:layout) { layout_cursor_action.layout.constantize }

    before do
      allow(layout).to receive(:run).and_call_original
    end

    it do
      subject

      expect(layout).to have_received(:run)
    end

    context 'when layout_cursor_action receives inputs' do
      let(:user) { FactoryBot.create(:user, :with_layout_cursor_action, layout: New) }
      let(:message_text) { '1) dvbnmnbvcxcvbj' }

      it do
        subject
        expect(layout).to have_received(:run)
      end
    end
  end
end

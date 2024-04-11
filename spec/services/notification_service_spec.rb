require 'rails_helper'

RSpec.describe NotificationService do
  describe "#call" do
    subject { described_class.new.call(message:) }

    let(:message) { double(:message, aggregate_id: user_id, data:) }

    let(:data) do
      {
        title:,
        body:,
        url:
      }
    end

    let(:title) { Faker::Lorem.sentence }
    let(:body) { Faker::Lorem.paragraph }
    let(:url) { Faker::Internet.url }

    let(:user_id) { SecureRandom.uuid }

    it "creates a notification" do
      expect { subject }.to change(Contact::Notification, :count).by(1)
      expect(Contact::Notification.last_created).to have_attributes(
        user_id:,
        title:,
        body:,
        url:
      )
    end
  end
end

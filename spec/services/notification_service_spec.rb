require 'rails_helper'

RSpec.describe NotificationService do
  describe "#call" do
    subject { described_class.new.call(event:) }

    let(:event) { double(:event, aggregate_id: user.id, data:) }

    let(:data) do
      {
        title:,
        body:,
        url:
      }
    end

    let(:email) { user.email }
    let(:title) { Faker::Lorem.sentence }
    let(:body) { Faker::Lorem.paragraph }
    let(:url) { Faker::Internet.url }

    let(:user) { create(:user) }

    it "creates a notification" do
      expect { subject }.to change(Notification, :count).by(1)
      expect(Notification.last_created).to have_attributes(
        user:,
        title:,
        body:,
        url:
      )
    end
  end
end

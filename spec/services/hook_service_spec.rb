require 'rails_helper'

RSpec.describe HookService do
  describe "#create_notification" do
    subject do
      described_class.new.create_notification(
        email:,
        title:,
        body:,
        url:
      )
    end

    let(:email) { user.email }
    let(:title) { Faker::Lorem.sentence }
    let(:body) { Faker::Lorem.paragraph }
    let(:url) { Faker::Internet.url }

    let(:user) { create(:user) }

    it "enqueues a notification created event job" do
      expect(EventService).to receive(:create!).with(
        event_type: Event::EventTypes::NOTIFICATION_CREATED,
        aggregate_id: user.id,
        data: {
          title:,
          body:,
          url:
        },
        occurred_at: be_present
      )

      subject
    end
  end
end

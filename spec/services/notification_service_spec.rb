require 'rails_helper'

RSpec.describe NotificationService do
  describe "#call" do
    subject { described_class.new.call(event:) }

    let(:event) { double(:event, data:) }

    let(:data) do
      {
        "email" => email,
        "title" => title,
        "body" => body,
        "url" => url,
      }
    end
    
    let(:email) { user.email }
    let(:title) { Faker::Lorem.sentence }
    let(:body) { Faker::Lorem.paragraph }
    let(:url) { Faker::Internet.url }

    let(:user) { create(:user) }

    it "creates a notification" do
      expect { subject }.to change { Notification.count }.by(1)
      expect(Notification.last_created).to have_attributes(
        user:,
        title:,
        body:,
        url:,
      )
    end
  end
end
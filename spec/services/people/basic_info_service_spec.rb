require 'rails_helper'

RSpec.describe People::BasicInfoService do
  describe ".update" do
    subject { described_class.new(user_id, message_service).update(about:, first_name:, last_name:, phone_number:, zip_code:) }

    let(:message_service) { MessageService.new }
    let(:user_id) { user.id }
    let(:user) { create(:user) }
    let!(:seeker) { create(:seeker, user_id: user.id) }
    let(:about) { "New About" }
    let(:first_name) { "New First Name" }
    let(:last_name) { "New Last Name" }
    let(:phone_number) { "1234567890" }
    let(:zip_code) { "12345" }
    let(:aggregate) { Aggregates::Person.new(person_id: seeker.id) }

    before do
      allow(MessageService)
        .to receive(:aggregate_events)
        .with(aggregate)
        .and_return(
          [
            build(
              :message,
              schema: Events::BasicInfoAdded::V1,
              aggregate_id: seeker.id,
              data: {
                first_name: "A name",
                last_name: "A name",
                phone_number: "333-333-3333",
                email: "cool@beans.com"
              }
            )
          ]
        )
    end

    it "publishes a basic info added event" do
      allow(message_service).to receive(:create!)
      expect(message_service).to receive(:create!).with(
        schema: Events::BasicInfoAdded::V1,
        stream:,
        data: {
          first_name:,
          last_name:,
          phone_number:,
          email: "cool@beans.com"
        }
      ).and_call_original

      expect(message_service).to receive(:create!).with(
        schema: Events::ZipAdded::V2,
        stream:,
        data: {
          zip_code:
        }
      ).and_call_original

      expect(message_service).to receive(:create!).with(
        schema: Events::PersonAboutAdded::V1,
        stream:,
        data: {
          about:
        }
      ).and_call_original

      subject
    end
  end
end

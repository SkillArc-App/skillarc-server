require 'rails_helper'

RSpec.describe Seekers::UserService do
  describe ".update" do
    subject { described_class.new(id).update(first_name:, last_name:, phone_number:, zip_code:) }

    let(:id) { user.id }
    let(:user) { create(:user) }
    let(:first_name) { "New First Name" }
    let(:last_name) { "New Last Name" }
    let(:phone_number) { "1234567890" }
    let(:zip_code) { "12345" }

    it "updates the user" do
      expect { subject }
        .to change { user.reload.first_name }.to(first_name)
        .and change { user.reload.last_name }.to(last_name)
        .and change { user.reload.phone_number }.to(phone_number)
        .and change { user.reload.zip_code }.to(zip_code)
    end

    it "publishes a user_updated event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::UserUpdated::V1,
        aggregate_id: id,
        data: Events::Common::UntypedHashWrapper.new(
          first_name:,
          last_name:,
          phone_number:,
          zip_code:
        ),
        occurred_at: be_a(Time)
      ).and_call_original

      subject
    end
  end
end

require 'rails_helper'

RSpec.describe Seekers::UserService do
  describe ".update" do
    subject { described_class.new(user_id).update(about:, first_name:, last_name:, phone_number:, zip_code:) }

    include_context "event emitter"

    let(:user_id) { user.id }
    let(:user) { create(:user) }
    let!(:seeker) { create(:seeker, user:) }
    let(:about) { "New About" }
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
      allow_any_instance_of(MessageService).to receive(:create!)
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::UserUpdated::V1,
        user_id:,
        data: {
          first_name:,
          last_name:,
          phone_number:,
          zip_code:
    },
        occurred_at: be_a(Time)
      ).and_call_original

      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::SeekerUpdated::V1,
        seeker_id: seeker.id,
        data: {
          about:
  },
        occurred_at: be_a(Time)
      ).and_call_original

      subject
    end

    it "updates the seeker" do
      expect { subject }
        .to change { user.reload.seeker.about }.to(about)
    end
  end
end

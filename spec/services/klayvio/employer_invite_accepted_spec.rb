require 'rails_helper'

RSpec.describe Klayvio::EmployerInviteAccepted do
  describe "#call" do
    let(:message) do
      build(:message, :employer_invite_accepted, data: {
              employer_invite_id:,
              invite_email: "sbf@crook.com",
              employer_id:,
              employer_name: "FTX"
            })
    end
    let(:employer_id) { SecureRandom.uuid }
    let(:employer_invite_id) { SecureRandom.uuid }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::FakeGateway).to receive(:employer_invite_accepted).with(
        email: "sbf@crook.com",
        event_id: message.id,
        profile_properties: {
          is_recruiter: true,
          employer_name: "FTX",
          employer_id:
        },
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end

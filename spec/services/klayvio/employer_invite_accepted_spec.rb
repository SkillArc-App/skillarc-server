require 'rails_helper'

RSpec.describe Klayvio::EmployerInviteAccepted do
  describe "#call" do
    let(:message) do
      build(:events__message, :employer_invite_accepted, data: Events::Common::UntypedHashWrapper.new(
        employer_invite_id: "A",
        invite_email: "sbf@crook.com",
        employer_id: "1",
        employer_name: "FTX"
      ))
    end

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:employer_invite_accepted).with(
        email: "sbf@crook.com",
        event_id: message.id,
        profile_properties: {
          is_recruiter: true,
          employer_name: "FTX",
          employer_id: "1"
        },
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end

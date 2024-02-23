require 'rails_helper'

RSpec.describe Klayvio::TrainingProviderInviteAccepted do
  describe "#call" do
    let(:message) do
      build(
        :message,
        event_type: Events::TrainingProviderInviteAccepted::V1.event_type,
        version: Events::TrainingProviderInviteAccepted::V1.version,
        data: Messages::UntypedHashWrapper.new(
          training_provider_invite_id: "A",
          invite_email: "sfb@crook.com",
          training_provider_id: "1",
          training_provider_name: "FTX"
        )
      )
    end

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:training_provider_invite_accepted).with(
        email: "sfb@crook.com",
        event_id: message.id,
        profile_properties: {
          is_training_provider: true,
          training_provider_name: "FTX",
          training_provider_id: "1"
        },
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end

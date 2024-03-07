require 'rails_helper'

RSpec.describe Klayvio::TrainingProviderInviteAccepted do
  describe "#call" do
    let(:message) do
      build(
        :message,
        message_type: Events::TrainingProviderInviteAccepted::V1.message_type,
        version: Events::TrainingProviderInviteAccepted::V1.version,
        data: Events::TrainingProviderInviteAccepted::Data::V1.new(
          training_provider_invite_id: SecureRandom.uuid,
          invite_email: "sfb@crook.com",
          training_provider_id:,
          training_provider_name: "FTX"
        )
      )
    end
    let(:training_provider_id) { SecureRandom.uuid }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:training_provider_invite_accepted).with(
        email: "sfb@crook.com",
        event_id: message.id,
        profile_properties: {
          is_training_provider: true,
          training_provider_name: "FTX",
          training_provider_id:
        },
        occurred_at: message.occurred_at
      )

      subject.call(message:)
    end
  end
end

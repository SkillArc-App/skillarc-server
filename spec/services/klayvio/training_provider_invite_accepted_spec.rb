require 'rails_helper'

RSpec.describe Klayvio::TrainingProviderInviteAccepted do
  describe "#call" do
    let(:event) do
      build(:event_message, :training_provider_invite_accepted, data: {
              training_provider_invite_id: "A",
              invite_email: "sfb@crook.com",
              training_provider_id: "1",
              training_provider_name: "FTX"
            })
    end

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:training_provider_invite_accepted).with(
        email: "sfb@crook.com",
        event_id: event.id,
        profile_properties: {
          is_training_provider: true,
          training_provider_name: "FTX",
          training_provider_id: "1"
        },
        occurred_at: event.occurred_at
      )

      subject.call(event:)
    end
  end
end

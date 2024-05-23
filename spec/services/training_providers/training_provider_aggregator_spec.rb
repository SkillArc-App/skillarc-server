require 'rails_helper'

RSpec.describe TrainingProviders::TrainingProviderAggregator do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new }

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "reference created" do
      let(:message) do
        build(
          :message,
          schema: Events::ReferenceCreated::V1,
          aggregate_id: reference_id,
          data: {
            reference_text: 'This is a reference',
            author_training_provider_profile_id:,
            seeker_id:
          }
        )
      end
      let(:reference_id) { SecureRandom.uuid }
      let(:seeker_id) { create(:seeker).id }
      let(:author_training_provider_profile_id) { create(:training_provider_profile).id }

      it "creates a reference" do
        expect { subject }.to change { Reference.count }.by(1)
      end
    end

    context "reference updated" do
      let(:message) do
        build(
          :message,
          schema: Events::ReferenceUpdated::V1,
          aggregate_id: reference_id,
          data: {
            reference_text: 'This is another reference'
          }
        )
      end
      let(:reference_id) { create(:reference).id }

      it "updates the reference" do
        expect { subject }.to change { Reference.find(reference_id).reference_text }.to('This is another reference')
      end
    end
  end
end

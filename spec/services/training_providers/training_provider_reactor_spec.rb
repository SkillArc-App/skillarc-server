require 'rails_helper'

RSpec.describe TrainingProviders::TrainingProviderReactor do
  it_behaves_like "a replayable message consumer"

  let(:instance) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }

  describe '#create_reference' do
    subject do
      instance.create_reference(
        reference_text:,
        seeker_id:,
        author_training_provider_profile_id:,
        trace_id:
      )
    end
    let(:reference_text) { 'This is a reference' }
    let(:seeker_id) { create(:seeker).id }
    let(:author_training_provider_profile_id) { create(:training_provider_profile).id }
    let(:trace_id) { SecureRandom.uuid }

    it 'creates a reference created event' do
      expect(message_service).to receive(:create!)
        .with(
          schema: Events::ReferenceCreated::V1,
          reference_id: be_a(String),
          data: {
            reference_text:,
            author_training_provider_profile_id:,
            seeker_id:
          },
          trace_id:
        ).and_call_original

      subject
    end
  end

  describe '#update_reference' do
    subject do
      instance.update_reference(
        reference_id:,
        reference_text:,
        trace_id:
      )
    end
    let(:reference_id) { SecureRandom.uuid }
    let(:reference_text) { 'This is a reference' }
    let(:trace_id) { SecureRandom.uuid }

    let(:reference_created) do
      build(
        :message,
        aggregate:,
        schema: Events::ReferenceCreated::V1,
        data: {
          reference_text:,
          author_training_provider_profile_id:,
          seeker_id:
        }
      )
    end
    let(:aggregate) { Aggregates::Reference.new(reference_id:) }
    let(:author_training_provider_profile_id) { SecureRandom.uuid }
    let(:seeker_id) { SecureRandom.uuid }

    before do
      allow(MessageService).to receive(:aggregate_events).and_return([reference_created])
    end

    it 'creates a reference updated event' do
      expect(message_service).to receive(:create!)
        .with(
          schema: Events::ReferenceUpdated::V1,
          reference_id:,
          trace_id:,
          data: {
            reference_text:
          }
        ).and_call_original

      subject
    end
  end
end

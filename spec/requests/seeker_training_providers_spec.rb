require 'rails_helper'

RSpec.describe "SeekerTrainingProviders", type: :request do
  include_context "admin authenticated"

  let!(:training_provider) { create(:training_provider) }
  let!(:program) { create(:program, training_provider:) }

  let(:seeker) { create(:seeker, user:) }

  describe "POST /create" do
    subject { post seeker_training_providers_path(seeker), params:, headers: }

    let(:params) do
      {
        programId: program.id,
        trainingProviderId: training_provider.id
      }
    end

    it "returns a 201" do
      subject

      expect(response).to have_http_status(:created)
    end

    it "emits a message" do
      expect_any_instance_of(MessageService)
        .to receive(:create!)
        .with(
          schema: Events::SeekerTrainingProviderCreated::V4,
          trace_id: be_a(String),
          seeker_id: seeker.id,
          data: {
            id: be_a(String),
            program_id: params[:programId],
            training_provider_id: params[:trainingProviderId],
            status: "Enrolled"
          }
        )
        .and_call_original

      subject
    end
  end

  describe "PUT /update" do
    subject { put seeker_training_provider_path(seeker, stp), params:, headers: }

    let(:stp) { create(:seeker_training_provider, seeker:, training_provider:, program:) }
    let!(:new_training_provider) { create(:training_provider) }
    let!(:new_program) { create(:program, training_provider:) }

    let(:params) do
      {
        programId: new_program.id,
        trainingProviderId: new_training_provider.id
      }
    end

    it "returns a 202" do
      subject

      expect(response).to have_http_status(:accepted)
    end

    it "emits a message" do
      expect_any_instance_of(MessageService)
        .to receive(:create!)
        .with(
          schema: Events::SeekerTrainingProviderCreated::V4,
          trace_id: be_a(String),
          seeker_id: seeker.id,
          data: {
            id: be_a(String),
            program_id: params[:programId],
            training_provider_id: params[:trainingProviderId],
            status: stp.status
          }
        )
        .and_call_original

      subject
    end
  end
end

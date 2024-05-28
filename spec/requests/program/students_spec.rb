require 'rails_helper'

RSpec.describe "Program::Students", type: :request do
  describe "PUT /update" do
    subject { put program_student_path(program, student), params:, headers: }

    include_context "training provider authenticated"

    let(:params) do
      {
        status: "accepted",
        program_id: program.id
      }
    end
    let!(:training_provider) { create(:training_provider) }
    let!(:program) { create(:program, training_provider:) }
    let!(:training_provider_profile) do
      TrainingProviderProfile.create!(
        id: SecureRandom.uuid,
        user:,
        training_provider:
      )
    end

    let!(:user) do
      User.create!(
        id: 'clem7u5uc0007mi0rne4h3be0',
        first_name: 'Jake',
        last_name: 'Not-Onboard',
        email: 'jake@statefarm.com',
        sub: 'jakesub'
      )
    end

    let!(:student_user) { create(:user) }
    let!(:student) { create(:seeker, user_id: student_user.id) }
    let!(:seeker_training_provider) do
      create(
        :seeker_training_provider,
        training_provider:,
        program:,
        seeker_id: student.id
      )
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(:accepted)
    end

    it "creates a program status" do
      expect_any_instance_of(MessageService)
        .to receive(:create!)
        .with(
          seeker_id: student.id,
          trace_id: be_a(String),
          schema: Events::SeekerTrainingProviderCreated::V4,
          data: {
            id: seeker_training_provider.id,
            status: params[:status],
            program_id: params[:program_id],
            training_provider_id: training_provider.id
          }
        )
        .and_call_original

      subject
    end
  end
end

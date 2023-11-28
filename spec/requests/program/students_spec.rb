require 'rails_helper'

RSpec.describe "Program::Students", type: :request do
  describe "PUT /update" do
    subject { put program_student_path(program, student), params:, headers: headers }

    include_context "training provider authenticated"

    let(:params) do
      {
        status: "accepted",
        program_id: program.id,
      }
    end
    let!(:training_provider) { create(:training_provider) }
    let!(:program) { create(:program, training_provider:) }
    let!(:training_provider_profile) do
      tpp = TrainingProviderProfile.create!(
        id: SecureRandom.uuid,
        user:,
        training_provider:
      )
    end


    let!(:user) do
      User.create!(
        id: 'clem7u5uc0007mi0rne4h3be0',
        name: 'Jake Not-Onboard',
        first_name: 'Jake',
        last_name: 'Not-Onboard',
        email: 'jake@statefarm.com',
        sub: 'jakesub'
      )
    end

    let!(:student_user) { create(:user) }
    let!(:student) { create(:profile, user: student_user) }
    let!(:seeker_training_provider) do
      create(
        :seeker_training_provider,
        training_provider: training_provider,
        program: program,
        user: student_user,
      )
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a program status" do
      expect { subject }.to change { SeekerTrainingProviderProgramStatus.count }.by(1)
    end
  end
end

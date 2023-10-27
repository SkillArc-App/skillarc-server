require 'rails_helper'

RSpec.describe "TrainingProviders::Programs", type: :request do
  describe "GET /index" do
    subject { get training_providers_programs_path }

    it_behaves_like "training provider secured endpoint"
  end

  describe "POST /create" do
    include_context "admin authenticated"

    subject { post training_provider_programs_path(training_provider_id: training_provider.id), params: params }

    let(:params) do
      {
        program: {
          name: "Program Name",
          description: "Program Description"
        }
      }
    end
    let(:training_provider) { create(:training_provider) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a program" do
      expect { subject }.to change { Program.count }.by(1)
    end
  end

  describe "PUT /update" do
    include_context "admin authenticated"

    subject { put training_provider_program_path(training_provider_id: training_provider.id, id: program.id), params: params }

    let(:params) do
      {
        program: {
          name: "Program Name",
          description: "Program Description"
        }
      }
    end
    let(:training_provider) { create(:training_provider) }
    let(:program) { create(:program, training_provider: training_provider) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "updates the program" do
      subject

      expect(program.reload.name).to eq("Program Name")
      expect(program.reload.description).to eq("Program Description")
    end
  end
end

require 'rails_helper'

RSpec.describe "Employers::Chats", type: :request do
  describe "GET /index" do
    subject { get chats_path }

    it_behaves_like "employer secured endpoint"

    context "when the employer has a recruiter" do
      include_context "employer authenticated"

      it "calls the EmployerChats service" do
        expect(EmployerChats).to receive(:new).with(recruiter).and_call_original

        expect_any_instance_of(EmployerChats).to receive(:get)

        subject
      end
    end
  end

  describe "POST /send_message" do
    subject { post send_message_chats_path, params: params }

    let(:params) do
      {
        applicant_id: applicant.id,
        message: "We are interested in your application"
      }
    end
    let(:applicant) { create(:applicant) }

    it_behaves_like "employer secured endpoint"

    context "when the employer has a recruiter" do
      include_context "employer authenticated"

      it "calls the EmployerChats service" do
        expect(EmployerChats).to receive(:new).with(recruiter).and_call_original

        expect_any_instance_of(EmployerChats)
          .to receive(:send_message)
          .with(
            applicant_id: applicant.id,
            message: "We are interested in your application"
          )

        subject
      end
    end
  end

  describe "POST /create" do
    subject { post chats_path, params: params }

    let(:params) do
      {
        applicant_id: applicant.id,
      }
    end
    let(:applicant) { create(:applicant) }

    it_behaves_like "employer secured endpoint"

    context "when the employer has a recruiter" do
      include_context "employer authenticated"

      it "calls the EmployerChats service" do
        expect(EmployerChats).to receive(:new).with(recruiter).and_call_original

        expect_any_instance_of(EmployerChats)
          .to receive(:create)
          .with(
            applicant_id: applicant.id,
          )

        subject
      end
    end
  end
end
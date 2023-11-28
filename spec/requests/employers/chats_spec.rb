require 'rails_helper'

RSpec.describe "Employers::Chats", type: :request do
  describe "GET /index" do
    subject { get chats_path, headers: headers }

    it_behaves_like "employer secured endpoint"

    context "when the employer has a recruiter" do
      include_context "employer authenticated"

      it "calls the EmployerChats service" do
        expect(EmployerChats).to receive(:new).with(EmployerChats::Recruiter.new(
          user: user,
          employer_id: employer.id
        )).and_call_original
        

        expect_any_instance_of(EmployerChats).to receive(:get)

        subject
      end
    end

    context "when the user is an employer admin" do
      include_context "employer authenticated"

      let(:recruiter) { nil }

      before do
        create(:user_role, user: user, role: Role.create!(id: SecureRandom.uuid, name: "employer_admin"))
      end

      it "calls the EmployerChats service" do
        expect(EmployerChats).to receive(:new).with(
          EmployerChats::Recruiter.new(
            user: user,
            employer_id: [employer.id]
          )
        ).and_call_original

        expect_any_instance_of(EmployerChats).to receive(:get)

        subject
      end
    end
  end

  describe "POST /mark_read" do
    subject { post mark_read_chats_path, params: params, headers: headers }

    let(:params) do
      {
        applicant_id: applicant.id
      }
    end
    let(:applicant) { create(:applicant) }

    it_behaves_like "employer secured endpoint"

    context "when the employer has a recruiter" do
      include_context "employer authenticated"

      it "calls the EmployerChats service" do
        expect(EmployerChats).to receive(:new).with(EmployerChats::Recruiter.new(
          user: user,
          employer_id: employer.id
        )).and_call_original

        expect_any_instance_of(EmployerChats).to receive(:mark_read).with(
          applicant_id: applicant.id
        )

        subject
      end
    end
  end

  describe "POST /send_message" do
    subject { post send_message_chats_path, params: params, headers: headers }

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
        expect(EmployerChats).to receive(:new).with(EmployerChats::Recruiter.new(
          user: user,
          employer_id: employer.id
        )).and_call_original

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
    subject { post chats_path, params: params, headers: headers }

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
        expect(EmployerChats).to receive(:new).with(EmployerChats::Recruiter.new(
          user: user,
          employer_id: employer.id
        )).and_call_original

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
require 'rails_helper'

RSpec.describe "Seekers::Chats", type: :request do
  describe "GET /index" do
    subject { get "/seekers/chats" }

    it_behaves_like "a secured endpoint"

    context "when the user is a seeker" do
      include_context "authenticated"

      it "calls the SeekerChats service" do
        expect(SeekerChats).to receive(:new).with(user).and_call_original

        expect_any_instance_of(SeekerChats).to receive(:get)

        subject
      end
    end
  end

  describe "POST /mark_read" do
    subject { post "/seekers/chats/mark_read", params: params }

    let(:params) do
      {
        applicant_id: applicant.id
      }
    end
    let(:applicant) { create(:applicant) }

    it_behaves_like "a secured endpoint"

    context "when the user is a seeker" do
      include_context "authenticated"

      it "calls the SeekerChats service" do
        expect(SeekerChats).to receive(:new).with(user).and_call_original

        expect_any_instance_of(SeekerChats).to receive(:mark_read).with(
          applicant_id: applicant.id
        )

        subject
      end
    end
  end

  describe "POST /send_message" do
    subject { post "/seekers/chats/send_message", params: params }

    let(:params) do
      {
        applicant_id: applicant.id,
        message: "I am interested in your job"
      }
    end

    let(:applicant) { create(:applicant) }

    it_behaves_like "a secured endpoint"

    context "when the user is a seeker" do
      include_context "authenticated"

      it "calls the SeekerChats service" do
        expect(SeekerChats).to receive(:new).with(user).and_call_original

        expect_any_instance_of(SeekerChats).to receive(:send_message).with(
          applicant_id: applicant.id,
          message: params[:message]
        )

        subject
      end
    end
  end
end

require 'rails_helper'

RSpec.describe EmployerChats do
  let!(:recruiter) { create(:recruiter, employer:, user: recruiter_user) }
  let(:employer) { create(:employer) }

  let(:recruiter_user) { create(:user, first_name: "Recruiter", last_name: "User") }

  describe "#get" do
    subject { described_class.new(recruiter).get }

    let!(:applicant) { create(:applicant, job:, profile:) }
    let!(:profile) { create(:profile, user:) }
    let(:user) { create(:user, first_name: "Hannah", last_name: "Block") }

    let(:job) { create(:job, employer:, employment_title: "Welder") }

    let!(:applicant_chat) { create(:applicant_chat, applicant:) }
    let!(:chat_message) { create(:chat_message, applicant_chat:, message: "This is a message from the applicant", user:) }
    let!(:chat_message2) { create(:chat_message, applicant_chat:, message: "This is a message from the recruiter", user: recruiter.user, created_at: chat_message.created_at + 1.minute) }

    let!(:read_receipt) { create(:read_receipt, chat_message:, user: recruiter_user) }

    it "returns the applicant chat" do
      expect(subject.first).to eq(
        {
          id: applicant_chat.applicant.id,
          name: "Hannah Block - Welder",
          updatedAt: chat_message2.created_at,
          messages: [
            {
              id: chat_message.id,
              text: "This is a message from the applicant",
              isUser: false,
              isRead: true,
              sender: "Hannah Block"
            },
            {
              id: chat_message2.id,
              text: "This is a message from the recruiter",
              isUser: true,
              isRead: false,
              sender: "Recruiter User"
            }
          ]
        }
      )
    end
  end

  describe "#mark_read" do
    subject { described_class.new(recruiter).mark_read(applicant_id: applicant.id) }

    let!(:applicant_chat) { create(:applicant_chat, applicant:) }
    let!(:chat_message) { create(:chat_message, applicant_chat:, message: "This is a message from the applicant", user:) }
    let!(:chat_message2) { create(:chat_message, applicant_chat:, message: "This is a message from the applicant") }

    let!(:applicant) { create(:applicant, profile:) }

    let!(:profile) { create(:profile, user:) }
    let(:user) { create(:user, first_name: "Hannah", last_name: "Block") }

    it "creates a read receipt for each message" do
      expect { subject }.to change(ReadReceipt, :count).by(2)
    end
  end

  describe "#send_message" do
    subject { described_class.new(recruiter).send_message(applicant_id: applicant.id, message:) }

    let(:message) { "This is a message" }

    let!(:applicant) { create(:applicant, job:, profile:) }
    let!(:applicant_chat) { create(:applicant_chat, applicant:) }
    let!(:profile) { create(:profile, user:) }
    let(:user) { create(:user, first_name: "Hannah", last_name: "Block") }

    let(:job) { create(:job, employer:, employment_title: "Welder") }

    it "creates a chat message" do
      expect { subject }.to change(ChatMessage, :count).by(1)

      expect(ChatMessage.last_created).to have_attributes(
        applicant_chat:,
        message:,
        user: recruiter.user
      )
    end

    it "enqueues an event" do
      expect(EventService).to receive(:create!).with(
        event_type: Event::EventTypes::CHAT_MESSAGE_SENT,
        aggregate_id: job.id,
        data: {
          applicant_id: applicant.id,
          profile_id: profile.id,
          from_user_id: recruiter.user.id,
          employer_name: employer.name,
          employment_title: job.employment_title,
          message:
        },
        occurred_at: anything
      )

      subject
    end
  end

  describe "#create" do
    subject { described_class.new(recruiter).create(applicant_id: applicant.id) }

    let!(:applicant) { create(:applicant) }

    it "creates an applicant chat" do
      expect { subject }.to change(ApplicantChat, :count).by(1)

      expect(ApplicantChat.last_created).to have_attributes(
        applicant:
      )
    end

    it "enqueues an event" do
      expect(EventService).to receive(:create!).with(
        event_type: Event::EventTypes::CHAT_CREATED,
        aggregate_id: applicant.job.id,
        data: {
          applicant_id: applicant.id,
          profile_id: applicant.profile.id,
          user_id: applicant.profile.user.id,
          employment_title: applicant.job.employment_title
        },
        occurred_at: anything
      )

      subject
    end
  end
end

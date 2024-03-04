require 'rails_helper'

RSpec.describe SeekerChats do
  let(:user) { create(:user, first_name: "Jake", last_name: "Not-Onboard") }

  describe "#send_message" do
    subject { described_class.new(user).send_message(applicant_id: applicant.id, message:) }

    let(:message) { "This is a message" }
    let!(:applicant) { create(:applicant, job:, seeker:) }
    let(:seeker) { create(:seeker, user:) }

    let!(:applicant_chat) { create(:applicant_chat, applicant:) }

    let(:job) { create(:job, employment_title: "Welder", employer:) }

    let(:employer) { create(:employer, name: "Acme, Inc") }

    it "creates a chat message" do
      expect { subject }.to change(ChatMessage, :count).by(1)

      expect(ChatMessage.last).to have_attributes(
        applicant_chat:,
        message:,
        user:
      )
    end

    it "creates a chat message event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::ChatMessageSent::V1,
        job_id: job.id,
        data: Events::ChatMessageSent::Data::V1.new(
          applicant_id: applicant.id,
          seeker_id: seeker.id,
          from_user_id: user.id,
          employer_name: employer.name,
          employment_title: job.employment_title,
          message:
        )
      ).and_call_original

      subject
    end
  end

  describe "#get" do
    subject { described_class.new(user).get }

    let!(:applicant) { create(:applicant, job:, seeker:) }
    let(:job) { create(:job, employment_title: "Welder", employer:) }
    let(:employer) { create(:employer, name: "Acme, Inc") }
    let!(:seeker) { create(:seeker, user:) }

    let!(:applicant_chat) { create(:applicant_chat, applicant:) }

    let!(:chat_message) { create(:chat_message, applicant_chat:, message: "This is a message from the applicant", user:) }
    let!(:chat_message2) { create(:chat_message, applicant_chat:, message: "This is a message from the employer", user: employer_user, created_at: chat_message.created_at + 1.minute) }

    let(:employer_user) { create(:user, first_name: "John", last_name: "Doe") }

    let!(:read_receipt) { create(:read_receipt, chat_message:, user:) }

    it "returns the applicant chat" do
      expect(subject.first).to match(
        {
          id: applicant_chat.applicant.id,
          name: "Acme, Inc - Welder",
          updatedAt: chat_message2.created_at,
          messages: [
            {
              id: chat_message.id,
              text: "This is a message from the applicant",
              isUser: true,
              isRead: true,
              sender: "Jake Not-Onboard"
            },
            {
              id: chat_message2.id,
              text: "This is a message from the employer",
              isUser: false,
              isRead: false,
              sender: "John Doe"
            }
          ]
        }
      )
    end
  end

  describe "#mark_read" do
    subject { described_class.new(user).mark_read(applicant_id: applicant.id) }

    let!(:applicant_chat) { create(:applicant_chat, applicant:) }
    let!(:chat_message) { create(:chat_message, applicant_chat:, message: "This is a message from the applicant", user:) }
    let!(:chat_message2) { create(:chat_message, applicant_chat:, message: "This is a message from the applicant") }

    let!(:applicant) { create(:applicant, seeker:) }
    let(:seeker) { create(:seeker, user:) }

    it "creates a read receipt for each message" do
      expect { subject }.to change(ReadReceipt, :count).by(2)

      expect(ReadReceipt.last(2)).to include(
        have_attributes(
          user:,
          chat_message:
        ),
        have_attributes(
          user:,
          chat_message: chat_message2
        )
      )
    end
  end
end

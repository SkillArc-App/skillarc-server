require 'rails_helper'

RSpec.describe Contact::ContactAggregator do
  describe "#handle_message" do
    subject { described_class.new.handle_message(message) }

    context "when the message is notification created" do
      let(:message) do
        build(
          :message,
          schema: Events::NotificationCreated::V2,
          data: {
            title: "A title",
            body: "A body",
            url: "A url",
            notification_id: SecureRandom.uuid
          }
        )
      end

      it "persists a notification record" do
        subject

        notification = Contact::Notification.last_created
        expect(notification.id).to eq(message.data.notification_id)
        expect(notification.user_id).to eq(message.aggregate.user_id)
        expect(notification.title).to eq(message.data.title)
        expect(notification.body).to eq(message.data.body)
        expect(notification.url).to eq(message.data.url)
      end
    end

    context "when the message is notification marked read" do
      let(:message) do
        build(
          :message,
          schema: Events::NotificationMarkedRead::V2,
          data: {
            notification_ids: [notification1.id, notification2.id]
          }
        )
      end

      let(:notification1) { create(:contact__notification) }
      let(:notification2) { create(:contact__notification) }

      it "persists a notification record" do
        subject

        notification1.reload
        notification2.reload

        expect(notification1.read_at).to eq(message.occurred_at)
        expect(notification2.read_at).to eq(message.occurred_at)
      end
    end

    context "when the message is user created" do
      let(:message) do
        build(
          :message,
          schema: Events::UserCreated::V1,
          data: {
            email: "An@email.com"
          }
        )
      end

      it "persists a user contact record" do
        subject

        user_contact = Contact::UserContact.last_created

        expect(user_contact.user_id).to eq(message.aggregate.user_id)
        expect(user_contact.email).to eq(message.data.email)
        expect(user_contact.preferred_contact).to eq(Contact::ContactPreference::IN_APP_NOTIFICATION)
      end
    end

    context "when the message is user updated" do
      let(:message) do
        build(
          :message,
          aggregate_id: user_contact.user_id,
          schema: Events::UserUpdated::V1,
          data:
        )
      end

      let!(:user_contact) { create(:contact__user_contact, email: og_email) }
      let(:og_email) { Faker::Internet.email }
      let(:data) do
        {
          first_name: "John",
          last_name: "Chabot",
          email:,
          phone_number: "333-333-3333"
        }
      end

      context "when data includes email and phone number" do
        let(:email) { "an@email.com" }

        it "updates user_contact with phone number and email" do
          subject

          user_contact.reload
          expect(user_contact.phone_number).to eq("333-333-3333")
          expect(user_contact.email).to eq("an@email.com")
        end
      end

      context "when data doesn't include a email but does include a phone number" do
        let(:email) { Messages::UNDEFINED }

        it "updates user_contact with phone number but not email" do
          subject

          user_contact.reload
          expect(user_contact.phone_number).to eq("333-333-3333")
          expect(user_contact.email).to eq(og_email)
        end
      end
    end

    context "when the message is slack id added" do
      let(:message) do
        build(
          :message,
          aggregate_id: user_contact.user_id,
          schema: Events::SlackIdAdded::V1,
          data: {
            slack_id: "123"
          }
        )
      end

      let!(:user_contact) { create(:contact__user_contact) }

      it "updates user_contact slack_id" do
        subject

        user_contact.reload
        expect(user_contact.slack_id).to eq("123")
      end
    end

    context "when the message is contact preference set" do
      let(:message) do
        build(
          :message,
          aggregate_id: user_contact.user_id,
          schema: Events::ContactPreferenceSet::V1,
          data: {
            preference: Contact::ContactPreference::PHONE
          }
        )
      end

      let!(:user_contact) { create(:contact__user_contact) }

      it "updates user_contact slack_id" do
        subject

        user_contact.reload
        expect(user_contact.preferred_contact).to eq(Contact::ContactPreference::PHONE)
      end
    end
  end
end

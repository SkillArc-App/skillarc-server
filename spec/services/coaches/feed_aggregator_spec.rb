require 'rails_helper'

RSpec.describe Coaches::FeedAggregator do
  let(:consumer) { described_class.new }
  let(:id) { SecureRandom.uuid }

  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "when the message is seeker applied" do
      let(:message) do
        build(
          :message,
          schema: People::Events::PersonApplied::V1,
          data: {
            seeker_email: "email@google.com",
            seeker_phone_number: "444-444-4444",
            seeker_first_name: "John",
            seeker_last_name: "Dude",
            employment_title: "Job",
            employer_name: "Place"
          }
        )
      end

      it "Creates the feed event" do
        expect { subject }.to change(Coaches::FeedEvent, :count).from(0).to(1)

        feed_event = Coaches::FeedEvent.first
        expect(feed_event.occurred_at).to eq(message.occurred_at)
        expect(feed_event.person_id).to eq(message.stream.id)
        expect(feed_event.person_email).to eq("email@google.com")
        expect(feed_event.person_phone).to eq("444-444-4444")
        expect(feed_event.description).to eq("John Dude applied for Job at Place.")
      end
    end

    context "when the message is user created" do
      let(:message) do
        build(
          :message,
          schema: Users::Events::UserCreated::V1,
          data: {
            first_name: "John",
            last_name: "Dude",
            email: "sup@gmail.com"
          }
        )
      end

      it "Creates the feed event" do
        expect { subject }.to change(Coaches::FeedEvent, :count).from(0).to(1)

        feed_event = Coaches::FeedEvent.first
        expect(feed_event.occurred_at).to eq(message.occurred_at)
        expect(feed_event.person_id).to eq(nil)
        expect(feed_event.person_email).to eq("sup@gmail.com")
        expect(feed_event.person_phone).to eq(nil)
        expect(feed_event.description).to eq("John Dude signed up.")
      end
    end
  end
end

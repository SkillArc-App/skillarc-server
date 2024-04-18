require 'rails_helper'

RSpec.describe DbStreamAggregator do
  let(:consumer) do
    mc = MessageConsumer.new
    allow(mc).to receive(:handle_message).and_return(nil)
    allow(mc).to receive(:reset_for_replay)
    mc
  end

  let!(:event) { create(:event, :user_created, occurred_at: event_occurred_at) }
  let!(:event2) { create(:event, :user_created, occurred_at: event_occurred_at + 2.days) }

  let(:event_occurred_at) { Date.new(2020, 1, 1) }
  let(:instance) { described_class.build(consumer:, listener_name: "listener_name", message_service:) }
  let(:message_service) { MessageService.new }

  describe "#play" do
    subject { instance.play }

    before do
      allow(message_service)
        .to receive(:broadcast?)
        .and_return(true)
    end

    it "updates the bookmark" do
      expect_any_instance_of(ListenerBookmark).to receive(:update!).with(event_id: event2.id).and_call_original

      expect { subject }.to change {
        ListenerBookmark.find_by(consumer_name: "listener_name")&.event_id
      }.from(nil).to(event2.id)
    end

    it "publishes the new events" do
      id = SecureRandom.uuid
      trace_id = SecureRandom.uuid
      occurred_at = Time.zone.local(2020, 1, 1)

      event_lambda = lambda do
        message_service.create!(
          day: "day",
          schema: Events::DayElapsed::V1,
          id:,
          trace_id:,
          occurred_at:,
          data: {
            date: Time.zone.today,
            day_of_week: Time.zone.today.strftime("%A").downcase
          }
        )
      end

      allow(consumer).to receive(:handle_message).with(
        event.message
      ).and_return(event_lambda.call)

      expected_message = Message.new(
        id:,
        trace_id:,
        aggregate: Aggregates::Day.new(day: "day"),
        schema: Events::DayElapsed::V1,
        data: Events::DayElapsed::Data::V1.new(
          date: Time.zone.today,
          day_of_week: Time.zone.today.strftime("%A").downcase
        ),
        metadata: Messages::Nothing,
        occurred_at:
      )

      expect_any_instance_of(Pubsub).to receive(:publish).with(message: expected_message).and_call_original
      expect(BroadcastEventJob).to receive(:perform_later).with(expected_message)

      subject
    end

    context "when the first event raises an error" do
      it "updates the bookmark" do
        expect(consumer).to receive(:handle_message).with(
          event.message
        ).and_raise(StandardError)
        expect(instance.last_error).to eq(nil)

        expect { subject }.to raise_error(StandardError)

        expect(instance.last_error).to be_a(StandardError)
        expect(ListenerBookmark.find_by(consumer_name: "listener_name").event_id).to eq(nil)
      end
    end

    context "when the second event raises an error" do
      it "updates the bookmark" do
        expect(consumer).to receive(:handle_message).with(
          event.message
        )

        expect(consumer).to receive(:handle_message).with(
          event2.message
        ).and_raise(StandardError)
        expect(instance.last_error).to eq(nil)

        expect { subject }.to raise_error(StandardError)

        expect(instance.last_error).to be_a(StandardError)
        expect(ListenerBookmark.find_by(consumer_name: "listener_name").event_id).to eq(event.id)
      end
    end

    context "when there is no bookmark" do
      it "calls the consumer" do
        expect(consumer).to receive(:handle_message).with(
          be_a(Message)
        ).twice

        subject
      end
    end

    context "when there is a bookmark" do
      before do
        create(
          :listener_bookmark,
          consumer_name: "listener_name",
          event_id: bookmark_event.id
        )
      end

      let(:bookmark_event) { event }

      it "consumes the events after the bookmark" do
        expect(consumer).to receive(:handle_message).with(
          event2.message
        )

        expect(consumer).not_to receive(:handle_message).with(
          event.message
        )

        subject
      end

      context "when the bookmark is on the last event" do
        let(:bookmark_event) { event2 }

        it "does not update the bookmark" do
          expect { subject }.not_to(change { ListenerBookmark.find_by(consumer_name: "listener_name").event_id })
        end
      end
    end
  end

  describe "#replay" do
    subject { instance.replay }

    it "calls play" do
      expect(instance)
        .to receive(:play)

      subject
    end

    it "calls reset_for_replay on the consumer" do
      expect(consumer).to receive(:reset_for_replay)

      subject
    end

    context "when replayed more than once" do
      it "plays the events twice" do
        expect(consumer).to receive(:handle_message).with(
          event.message
        ).twice

        expect(consumer).to receive(:handle_message).with(
          event2.message
        ).twice

        instance.replay
        instance.replay
      end
    end

    context "when a bookmark already exists" do
      let!(:listener_bookmark) do
        create(
          :listener_bookmark,
          consumer_name: "listener_name",
          event_id: event.id
        )
      end

      it "destroyes the original bookmark" do
        subject

        expect { listener_bookmark.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#call" do
    it "calls play" do
      expect(instance)
        .to receive(:play)
        .and_call_original

      instance.call(event:)
    end
  end

  describe ".get_listener" do
    it "retrieves a listener if created" do
      described_class.build(consumer:, listener_name: "example", message_service: double)

      expect(StreamListener.get_listener("example")).to be_a(described_class)
      expect(StreamListener.get_listener(SecureRandom.uuid)).to eq(nil)
    end
  end
end

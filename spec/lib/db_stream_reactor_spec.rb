require 'rails_helper'

RSpec.describe DbStreamReactor do
  let(:consumer) { double(:consumer, handle_event: nil, reset_for_replay: nil) }

  let!(:event) { create(:event, :user_created, occurred_at: event_occurred_at) }
  let!(:event2) { create(:event, :user_created, occurred_at: event_occurred_at + 2.days) }

  let(:event_occurred_at) { Date.new(2020, 1, 1) }

  describe "#play" do
    subject { instance.play }

    let(:instance) { described_class.build(consumer, "listener_name") }

    it "updates the bookmark" do
      expect { subject }.to change {
        ListenerBookmark.find_by(consumer_name: "listener_name")&.event_id
      }.from(nil).to(event2.id)
    end

    context "when there is no bookmark" do
      it "calls the consumer" do
        expect(consumer).to receive(:handle_event).with(
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
        expect(consumer).to receive(:handle_event).with(
          event2.message
        )

        expect(consumer).not_to receive(:handle_event).with(
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

    let(:instance) { described_class.build(consumer, "listener_name") }

    it "calls play" do
      expect(instance)
        .to receive(:play)

      subject
    end

    it "calls reset_for_replay on the consumer" do
      expect(consumer).to receive(:reset_for_replay)

      subject
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
    subject { described_class.build(consumer, "listener_name") }

    it "calls the consumer with the event" do
      expect(consumer).to receive(:handle_event).with(
        event.message
      )

      expect(consumer).to receive(:handle_event).with(
        event2.message
      )

      subject.call(event:)
    end

    it "updates the bookmark" do
      expect { subject.call(event:) }.to change {
        ListenerBookmark.find_by(consumer_name: "listener_name")&.event_id
      }.from(nil).to(event2.id)
    end
  end

  describe ".get_listener" do
    it "retrieves a listener if created" do
      described_class.build(consumer, "example")

      expect(StreamListener.get_listener("example")).to be_a(described_class)
      expect(StreamListener.get_listener(SecureRandom.uuid)).to eq(nil)
    end
  end
end

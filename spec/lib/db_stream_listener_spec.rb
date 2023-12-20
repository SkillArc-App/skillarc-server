require 'rails_helper'

RSpec.describe DbStreamListener do
  let(:consumer) { double(:consumer, handle_event: nil) }

  let!(:event) { create(:event, :user_created, occurred_at: event_occurred_at) }
  let!(:event2) { create(:event, :user_created, occurred_at: event_occurred_at + 2.days) }

  let(:event_occurred_at) { Date.new(2020, 1, 1) }

  describe ".initialize" do
    subject { described_class.new(consumer, "listener_name") }

    it "updates the bookmark" do
      expect { subject }.to change {
        ListenerBookmark.find_by(consumer_name: "listener_name")&.event_id
      }.from(nil).to(event2.id)
    end

    context "when there is no bookmark" do
      it "consumes the events from the beginning with side effects" do
        expect(consumer).to receive(:handle_event).with(
          event,
          with_side_effects: true,
        )
        expect(consumer).to receive(:handle_event).with(
          event2,
          with_side_effects: true,
        )

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
          event2,
          with_side_effects: true,
        )

        expect(consumer).not_to receive(:handle_event).with(
          event,
          with_side_effects: false,
        )

        subject
      end

      context "when the bookmark is on the last event" do
        let(:bookmark_event) { event2 }

        it "does not update the bookmark" do
          expect { subject }.not_to change { ListenerBookmark.find_by(consumer_name: "listener_name").event_id }
        end
      end
    end
  end

  describe "#call" do
    subject { described_class.new(consumer, "listener_name") }

    it "calls the consumer with the event and with_side_effects: true" do
      event = create(:event, :user_created)

      expect(consumer).to receive(:handle_event).with(
        event,
        with_side_effects: true,
      )

      subject.call(event)
    end

    it "updates the bookmark" do
      expect { subject.call(event) }.to change {
        ListenerBookmark.find_by(consumer_name: "listener_name")&.event_id
      }.from(nil).to(event.id)
    end
  end
end
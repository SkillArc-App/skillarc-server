require 'rails_helper'

RSpec.describe DbStreamListener do
  describe ".initialize" do
    subject { described_class.new(consumer, "listener_name") }

    let(:consumer) { double(:consumer, handle_event: nil) }
    let!(:event) { create(:event, :user_created, occurred_at: event_occurred_at) }
    let!(:event2) { create(:event, :user_created, occurred_at: event_occurred_at + 2.days) }
    let(:event_occurred_at) { Date.new(2020, 1, 1) }

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
          event_id: event.id
        )
      end

      it "consumes the events to the bookmark with no side effects then with side effects" do
        expect(consumer).to receive(:handle_event).with(
          event,
          with_side_effects: false,
        )

        expect(consumer).to receive(:handle_event).with(
          event2,
          with_side_effects: true,
        )

        subject
      end
    end
  end
end
require 'rails_helper'

RSpec.describe DbStreamReactor do
  let(:consumer) { MessageConsumer.new }

  let!(:event) { create(:event, :user_created, occurred_at: event_occurred_at) }
  let!(:event2) { create(:event, :user_created, occurred_at: event_occurred_at + 2.days) }

  let(:event_occurred_at) { Date.new(2020, 1, 1) }
  let(:instance) { described_class.build(consumer:, listener_name: "listener_name", message_service: MessageService.new, now:) }
  let(:now) { Time.zone.now }

  describe "#play" do
    subject { instance.play }

    context "when the first event raises an error" do
      let(:now) { Time.zone.local(2019, 1, 1) }

      it "does not update the bookmark" do
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
      let(:now) { Time.zone.local(2019, 1, 1) }

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

    context "when now is before the events" do
      let(:now) { Time.zone.local(2019, 1, 1) }

      it "updates the bookmark" do
        expect { subject }.to change {
          ListenerBookmark.find_by(consumer_name: "listener_name")&.event_id
        }.from(nil).to(event2.id)
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

    context "when now is after the events" do
      let(:now) { Time.zone.local(2021, 1, 1) }

      it "does not updates the bookmark" do
        expect { subject }.not_to(change do
                                    ListenerBookmark.find_by(consumer_name: "listener_name")&.event_id
                                  end)
      end

      context "when there is no bookmark" do
        it "does not calls the consumer" do
          expect(consumer).not_to receive(:handle_message)

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
  end

  describe "#replay" do
    subject { instance.replay }

    it "does not calls play" do
      expect(instance)
        .not_to receive(:play)

      subject
    end

    it "does not call reset_for_replay on the consumer" do
      expect(consumer).not_to receive(:reset_for_replay)

      subject
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
      described_class.build(consumer:, listener_name: "example", message_service: MessageService.new)

      expect(StreamListener.get_listener("example")).to be_a(described_class)
      expect(StreamListener.get_listener(SecureRandom.uuid)).to eq(nil)
    end
  end
end

require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  describe "POST /mark_read" do
    subject { post notifications_mark_read_path, headers: }

    it_behaves_like "a secured endpoint"

    context "when authenticated" do
      include_context "authenticated"

      let!(:notification1) { create(:notification, user:) }
      let!(:notification2) { create(:notification, user:) }

      it "marks all notifications as read" do
        expect { subject }
          .to change { notification1.reload.read_at }.from(nil).to(Time)
          .and change { notification2.reload.read_at }.from(nil).to(Time)
      end

      it "publishes an event" do
        expect(EventService).to receive(:create!).with(
          event_type: Event::EventTypes::NOTIFICATIONS_MARKED_READ,
          aggregate_id: user.id,
          data: {
            notification_id: notification1.id
          }
        ).and_call_original

        expect(EventService).to receive(:create!).with(
          event_type: Event::EventTypes::NOTIFICATIONS_MARKED_READ,
          aggregate_id: user.id,
          data: {
            notification_id: notification2.id
          }
        ).and_call_original

        subject
      end
    end
  end
end

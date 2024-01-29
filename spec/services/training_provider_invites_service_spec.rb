require 'rails_helper'

RSpec.describe TrainingProviderInviteService do
  subject { described_class.new(training_provider_invite) }

  let(:training_provider_invite) { create(:training_provider_invite, email: user.email) }
  let!(:user) { create(:user) }

  describe "#accept" do
    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::TrainingProviderInviteAccepted::V1,
        aggregate_id: training_provider_invite.training_provider_id,
        data: Events::Common::UntypedHashWrapper.build(
          training_provider_invite_id: training_provider_invite.id,
          invite_email: training_provider_invite.email,
          training_provider_id: training_provider_invite.training_provider_id,
          training_provider_name: training_provider_invite.training_provider.name
        )
      ).and_call_original

      subject.accept
    end

    it "creates a new training provider profile" do
      expect do
        subject.accept
      end.to change(TrainingProviderProfile, :count).by(1)
    end

    it "updates the training provider invite status" do
      expect do
        subject.accept
      end.to change { training_provider_invite.reload.used_at }.from(nil).to(be_present)
    end
  end
end

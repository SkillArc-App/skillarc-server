require 'rails_helper'

RSpec.describe EmployerInviteService do
  subject { described_class.new(employer_invite) }

  let(:employer_invite) { create(:employer_invite, email: user.email) }
  let!(:user) { create(:user) }

  describe "#accept" do
    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::EmployerInviteAccepted::V1,
        aggregate_id: employer_invite.employer_id,
        data: Events::Common::UntypedHashWrapper.build(
          employer_invite_id: employer_invite.id,
          invite_email: employer_invite.email,
          employer_id: employer_invite.employer_id,
          employer_name: employer_invite.employer.name
        )
      ).and_call_original

      subject.accept
    end

    it "creates a new recruiter" do
      expect do
        subject.accept
      end.to change(Recruiter, :count).by(1)
    end

    it "updates the employer invite status" do
      expect do
        subject.accept
      end.to change { employer_invite.reload.used_at }.from(nil).to(be_present)
    end
  end
end

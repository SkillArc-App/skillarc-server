require 'rails_helper'

RSpec.describe EmployerInviteService do
  subject { described_class.new(employer_invite) }

  include_context "event emitter"

  let(:employer_invite) { create(:employer_invite, email: user.email) }
  let!(:user) { create(:user) }

  describe "#accept" do
    it "creates an event" do
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::EmployerInviteAccepted::V1,
        employer_id: employer_invite.employer_id,
        data: {
          employer_invite_id: employer_invite.id,
          invite_email: employer_invite.email,
          employer_id: employer_invite.employer_id,
          employer_name: employer_invite.employer.name
    }
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

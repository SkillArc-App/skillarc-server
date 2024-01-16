require 'rails_helper'

RSpec.describe EmployerInviteService do
  subject { described_class.new(employer_invite) }

  let(:employer_invite) { create(:employer_invite, email: user.email) }
  let!(:user) { create(:user) }

  describe "#accept" do
    it "creates an event" do
      expect(CreateEventJob).to receive(:perform_later).with(
        event_type: Event::EventTypes::EMPLOYER_INVITE_ACCEPTED,
        aggregate_id: employer_invite.employer_id,
        data: {
          employer_invite_id: employer_invite.id,
          invite_email: employer_invite.email,
          employer_id: employer_invite.employer_id,
          employer_name: employer_invite.employer.name
        },
        occurred_at: be_present,
        metadata: {}
      )

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

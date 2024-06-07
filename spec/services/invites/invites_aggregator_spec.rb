require 'rails_helper'

RSpec.describe Invites::InvitesAggregator do
  let(:consumer) { described_class.new }
  let(:id) { SecureRandom.uuid }

  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "when the message is employer invite created" do
      let(:message) do
        build(
          :message,
          schema: Events::EmployerInviteCreated::V1,
          data: {
            invite_email: "An email",
            first_name: "First",
            last_name: "Last",
            employer_id: SecureRandom.uuid,
            employer_name: "A name"
          }
        )
      end

      it "creates an employer invite" do
        expect { subject }.to change(Invites::EmployerInvite, :count).from(0).to(1)

        employer_invite = Invites::EmployerInvite.first
        expect(employer_invite.id).to eq(message.aggregate.id)
        expect(employer_invite.email).to eq(message.data.invite_email)
        expect(employer_invite.first_name).to eq(message.data.first_name)
        expect(employer_invite.last_name).to eq(message.data.last_name)
        expect(employer_invite.employer_id).to eq(message.data.employer_id)
        expect(employer_invite.employer_name).to eq(message.data.employer_name)
      end
    end

    context "when the message is employer invite accepted" do
      let(:message) do
        build(
          :message,
          schema: Events::EmployerInviteAccepted::V2,
          aggregate_id: employer_invite.id,
          data: {
            user_id: SecureRandom.uuid,
            invite_email: "a email",
            employer_id: SecureRandom.uuid,
            employer_name: "Employer"
          }
        )
      end

      let(:employer_invite) { create(:invites__employer_invite) }

      it "marks the employer invite as used" do
        subject

        employer_invite.reload
        expect(employer_invite.used_at).to eq(message.occurred_at)
      end
    end
  end
end

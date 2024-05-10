require 'rails_helper'

RSpec.describe Users::UsersAggregator do
  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject { described_class.new.handle_message(message) }

    context "when message is role added" do
      let(:message) do
        build(
          :message,
          schema: Events::RoleAdded::V2,
          aggregate_id: user.id,
          data: {
            role: role.name
          }
        )
      end

      let(:user) { create(:user) }
      let!(:role) { create(:role, name: Role::Types::ADMIN) }

      context "when the user role doesn't exist" do
        it "creates a user role" do
          expect { subject }.to change(UserRole, :count).from(0).to(1)

          user_role = UserRole.take(1).first
          expect(user_role.user).to eq(user)
          expect(user_role.role).to eq(role)
        end
      end

      context "when the user role does exist" do
        let!(:user_role) { create(:user_role, user:, role:) }

        it "creates a user role" do
          expect { subject }.not_to change(UserRole, :count)
        end
      end
    end
  end
end

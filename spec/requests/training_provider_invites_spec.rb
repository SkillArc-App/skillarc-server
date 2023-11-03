require 'rails_helper'

RSpec.describe "TrainingProviderInvites", type: :request do
  describe "GET /index" do
    subject { get training_provider_invites_path }
    
    it_behaves_like "admin secured endpoint"
  end

  describe "POST /accept" do
    subject { post accept_training_provider_invite_path(invite) }

    let(:invite) { create(:training_provider_invite, email: user.email) }
    let(:user) { create(:user) }

    it_behaves_like "a secured endpoint"
  end
end

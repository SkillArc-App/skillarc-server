require 'rails_helper'

RSpec.describe "TrainingProviderInvites", type: :request do
  describe "GET /index" do
    subject { get training_provider_invites_path }
    
    it_behaves_like "admin secured endpoint"
  end
end

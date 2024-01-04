require 'rails_helper'

RSpec.describe "TrainingProviders", type: :request do
  describe "GET /index" do
    subject { get training_providers_path, headers: }

    it_behaves_like "a secured endpoint"
  end
end

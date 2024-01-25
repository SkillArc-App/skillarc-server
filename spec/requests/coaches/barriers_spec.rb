require 'rails_helper'

RSpec.describe "Coaches::Barriers", type: :request do
  describe "GET /index" do
    subject { get barriers_path, headers: }

    it_behaves_like 'coach secured endpoint'
  end
end

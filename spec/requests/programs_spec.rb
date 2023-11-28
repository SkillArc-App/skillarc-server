require 'rails_helper'

RSpec.describe "Programs", type: :request do
  describe "GET /index" do
    subject { get programs_path, headers: headers }

    it_behaves_like "a secured endpoint"
  end
end

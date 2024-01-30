require 'rails_helper'

RSpec.describe "OneUsers", type: :request do
  describe "GET /index" do
    subject { get one_user_index_path, headers: }

    it_behaves_like "admin secured endpoint"
  end
end

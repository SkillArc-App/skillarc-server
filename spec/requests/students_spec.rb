require 'rails_helper'

RSpec.describe "Students", type: :request do
  describe "GET /index" do
    subject { get students_path }

    it_behaves_like "training provider secured endpoint"
  end
end

require 'rails_helper'

RSpec.describe "Employers::Jobs", type: :request do
  describe "GET /index" do
    subject { get employers_jobs_path, headers: headers }

    it_behaves_like "employer secured endpoint"
  end
end

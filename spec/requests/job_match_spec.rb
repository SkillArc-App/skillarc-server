require 'rails_helper'

RSpec.describe "JobMatches", type: :request do
  describe "GET /index" do
    
  end

  describe "GET /:profile_id" do
    it "returns http success" do
      get "/job_matches/047aebd1-f3af-41d0-b96f-1af8e7344ba8"
      expect(response).to have_http_status(:success)
    end
  end
end

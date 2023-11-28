require 'rails_helper'

RSpec.describe "Stories", type: :request do
  describe "POST /create" do
    include_context "authenticated"

    subject { post profile_stories_path(profile_id: profile.id), params: params, headers: headers }

    let(:params) do
      {
        story: {
          prompt: "This is a prompt",
          response: "This is a response",
        }
      }
    end
    let(:profile) { create(:profile, user: User.find("clem7u5uc0007mi0rne4h3be0")) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a story" do
      expect { subject }.to change { Story.count }.by(1)
    end
  end

  describe "UPDATE /update" do
    include_context "authenticated"

    let(:profile) { create(:profile, user: User.find("clem7u5uc0007mi0rne4h3be0")) }
    let!(:story) { create(:story, profile: profile) }

    subject { patch profile_story_path(profile_id: profile.id, id: story.id), params: params, headers: headers }

    let(:params) do
      {
        story: {
          prompt: "This is a new prompt",
          response: "This is a response",
        }
      }
    end

    it "returns a 200" do

      subject

      expect(response).to have_http_status(200)
    end

    it "updates the story" do
      expect { subject }.to change { story.reload.prompt }.to("This is a new prompt")
    end
  end

  describe "DELETE /destroy"
end

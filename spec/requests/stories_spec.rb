require 'rails_helper'

RSpec.describe "Stories", type: :request do
  describe "POST /create" do
    subject { post profile_stories_path(seeker), params:, headers: }

    include_context "authenticated"

    let(:params) do
      {
        story: {
          prompt: "This is a prompt",
          response: "This is a response"
        }
      }
    end
    let(:user) { create(:user) }
    let(:profile) { create(:profile, user:) }
    let(:seeker) { create(:seeker, id: profile.id, user:) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates a story" do
      expect { subject }.to change(Story, :count).by(1)
    end
  end

  describe "UPDATE /update" do
    subject { patch profile_story_path(seeker, story), params:, headers: }

    include_context "authenticated"

    let(:user) { create(:user) }
    let(:profile) { create(:profile, user:) }
    let(:seeker) { create(:seeker, id: profile.id, user:) }

    let(:params) do
      {
        story: {
          prompt: "This is a new prompt",
          response: "This is a response"
        }
      }
    end
    let!(:story) { create(:story, profile:) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "updates the story" do
      expect { subject }.to change { story.reload.prompt }.to("This is a new prompt")
    end
  end

  describe "DELETE /destroy"
end

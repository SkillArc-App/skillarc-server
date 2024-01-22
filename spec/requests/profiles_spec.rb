require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  describe "GET /index" do
    subject { get profiles_path, headers: }

    it_behaves_like "admin secured endpoint"
  end

  describe "GET /show" do
    subject { get profile_path(profile), headers: }

    let(:profile) { create(:profile) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    context "unauthenticated" do
      it "calls the profile service with profile editor false" do
        expect_any_instance_of(ProfileService)
          .to receive(:get).with(profile_editor: false)
          .and_call_original

        subject
      end
    end

    context "authenticated" do
      context "user is not the profile owner" do
        context "the user is a coach" do
          include_context "coach authenticated"

          it "calls the profile service with profile editor true" do
            expect_any_instance_of(ProfileService)
              .to receive(:get).with(profile_editor: true)
              .and_call_original

            subject
          end
        end

        context "the user is not a coach" do
          include_context "authenticated"

          context "user is profile owner" do
            let(:profile) { create(:profile, user:) }

            it "calls the profile service with profile editor true" do
              expect_any_instance_of(ProfileService)
                .to receive(:get).with(profile_editor: true)
                .and_call_original

              subject
            end
          end

          context "user is not profile owner" do
            it "calls the profile service with profile editor false" do
              expect_any_instance_of(ProfileService)
                .to receive(:get).with(profile_editor: false)
                .and_call_original

              subject
            end
          end
        end
      end
    end
  end

  describe "PUT /update" do
    subject { put profile_path(profile), params:, headers: }

    let(:profile) { create(:profile) }

    let(:params) do
      {
        profile: {
          bio: "New Bio",
          met_career_coach: true
        }
      }
    end

    it_behaves_like "admin secured endpoint"

    context "admin authenticated" do
      include_context "admin authenticated"

      it "updates the profile" do
        expect { subject }
          .to change { profile.reload.bio }.to("New Bio")
          .and change { profile.reload.met_career_coach }.to(true)
      end
    end
  end
end

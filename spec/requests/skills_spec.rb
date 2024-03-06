require 'rails_helper'

RSpec.describe "Skills", type: :request do
  let(:master_skill) { create(:master_skill) }
  let(:seeker) { create(:seeker, user: user_to_edit) }
  let(:user_to_edit) { create(:user) }

  describe "POST /create" do
    subject { post profile_skills_path(seeker), params:, headers: }

    let(:params) do
      {
        skill: {
          description: "This is a description",
          master_skill_id: master_skill.id
        }
      }
    end

    it_behaves_like "a seeker secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "calls the Seekers::SkillService" do
        expect(Seekers::SkillService)
          .to receive(:new)
          .with(seeker)
          .and_call_original

        expect_any_instance_of(Seekers::SkillService)
          .to receive(:create)
          .with(master_skill_id: master_skill.id, description: "This is a description")
          .and_call_original

        subject
      end
    end
  end

  describe "PUT /update" do
    subject { put profile_skill_path(seeker, skill), params:, headers: }

    let(:skill) { create(:profile_skill, seeker:) }

    let(:params) do
      {
        skill: {
          description: "This is a new description"
        }
      }
    end

    it_behaves_like "a seeker secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "calls the Seekers::SkillService" do
        expect(Seekers::SkillService)
          .to receive(:new)
          .with(seeker)
          .and_call_original

        expect_any_instance_of(Seekers::SkillService)
          .to receive(:update)
          .with(skill, description: "This is a new description")
          .and_call_original

        subject
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete profile_skill_path(seeker, skill), headers: }

    let!(:skill) { create(:profile_skill, seeker:) }

    it_behaves_like "a seeker secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "calls the Seekers::SkillService" do
        expect(Seekers::SkillService)
          .to receive(:new)
          .with(seeker)
          .and_call_original

        expect_any_instance_of(Seekers::SkillService)
          .to receive(:destroy)
          .with(skill)
          .and_call_original

        subject
      end
    end
  end
end

require 'rails_helper'

RSpec.describe FastTrackTasks do
  subject { described_class.new(user) }

  let(:user) { create(:user, profile: nil, onboarding_sessions: [onboarding_session]) }
  let(:onboarding_session) { build(:onboarding_session, completed_at:) }
  let(:completed_at) { Date.new(2020, 1, 1) }

  # shared examples
  shared_examples "base exits" do
    context "when the user is a training provider" do
      before do
        create(:training_provider_profile, user: user)
      end

      it "returns an empty array" do
        expect(result).to eq([])
      end
    end

    context "when the user is a recruiter" do
      before do
        create(:recruiter, user: user)
      end

      it "returns an empty array" do
        expect(result).to eq([])
      end
    end

    context "when onboarding is not complete" do
      let(:completed_at) { nil }

      it "returns an empty array" do
        expect(result).to eq([])
      end
    end
  end

  describe "#profile" do
    it_behaves_like "base exits" do
      let(:result) { subject.profile }
    end

    context "when the profile is nil" do
      it "returns 'Make your resume strong' as incomplete" do
        expect(subject.profile).to include({ name: "Make your resume strong", is_complete: false, route: "/" })
      end
    end

    context "when the profile is not nil" do
      let!(:profile) { create(:profile, user:, met_career_coach:) }
      let(:met_career_coach) { false }

      context "when ProfileCompleteness returns 'incomplete'" do
        it "returns 'Make your resume strong' as incomplete" do
          allow_any_instance_of(ProfileCompleteness).to receive(:status).and_return(ProfileCompleteness::Result.new("incomplete", ["education", "work"]))

          expect(subject.profile).to include({ name: "Make your resume strong", is_complete: false, route: "/profiles/#{profile.id}" })
        end
      end

      context "when ProfileCompleteness returns 'complete'" do
        it "returns 'Make your resume is strong' as complete" do
          allow_any_instance_of(ProfileCompleteness).to receive(:status).and_return(ProfileCompleteness::Result.new("complete", []))

          expect(subject.profile).to include({ name: "Make your resume strong", is_complete: true, route: "/profiles/#{profile.id}" })
        end
      end

      context "when the user has not met with a career coach" do
        it "returns 'Meet your career coach' as incomplete" do
          expect(subject.profile).to include({ name: "Meet your career coach", is_complete: false, route: "https://meetings.hubspot.com/hannah-wexner" })
        end
      end

      context "when the user has met with a career coach" do
        let(:met_career_coach) { true }

        it "returns 'Meet your career coach' as complete" do
          expect(subject.profile).to include({ name: "Meet your career coach", is_complete: true, route: "https://meetings.hubspot.com/hannah-wexner" })
        end
      end
    end
  end

  describe "#career" do
    it_behaves_like "base exits" do
      let(:result) { subject.career }
    end

    context "when the user is a recruiter" do
      before do
        create(:recruiter, user: user)
      end

      it "returns an empty array" do
        expect(subject.career).to eq([])
      end
    end

    context "when less than 3 jobs are saved" do
      it "returns 'Save 3 jobs' as incomplete" do
        expect(subject.career).to include({ name: "Save 3 jobs", is_complete: false, route: "/jobs" })
      end
    end

    context "when 3 or more jobs are saved" do
      it "returns 'Save 3 jobs' as complete" do
        allow(user).to receive(:saved_jobs).and_return([double, double, double])

        expect(subject.career).to include({ name: "Save 3 jobs", is_complete: true, route: "/jobs" })
      end
    end

    context "when a job is not applied to" do
      it "returns 'Apply to your first job' as incomplete" do
        expect(subject.career).to include({ name: "Apply to your first job", is_complete: false, route: "/jobs" })
      end
    end

    context "when a job is applied to" do
      it "returns 'Apply to your first job' as complete" do
        allow(user).to receive(:applied_jobs).and_return([double])

        expect(subject.career).to include({ name: "Apply to your first job", is_complete: true, route: "/jobs" })
      end
    end
  end
end

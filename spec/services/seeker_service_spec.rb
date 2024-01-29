require 'rails_helper'

RSpec.describe SeekerService do
  describe "#get" do
    subject { described_class.new(profile, nil).get(seeker_editor: true) }

    let(:profile) { create(:profile, user:) }
    let(:user) do
      create(
        :user,
        email: "seeker@blocktrainapp.com",
        first_name: "First",
        last_name: "Last",
        onboarding_sessions: [],
        phone_number: "1234567890",
        sub: "sub",
        zip_code: "43210"
      )
    end

    before do
      create(
        :onboarding_session,
        user: profile.user,
        responses: {
          "opportunityInterests" => {
            "response" => [
              "Manufacturing",
              "Healthcare"
            ]
          }
        }
      )

      create(
        :education_experience,
        profile:,
        organization_name: "University of Cincinnati",
        title: "Student",
        graduation_date: Date.new(2019, 5, 1),
        gpa: 3.5,
        activities: "Activities"
      )

      create(
        :other_experience,
        profile:,
        organization_name: "Turner Construction",
        position: "Laborer",
        start_date: Date.new(2015, 1, 1),
        end_date: Date.new(2019, 1, 1),
        is_current: false,
        description: "Description"
      )

      create(
        :personal_experience,
        profile:,
        activity: "Babysitting",
        start_date: Date.new(2019, 1, 1),
        end_date: Date.new(2020, 1, 1),
        description: "I babysat for my neighbor's kids."
      )

      create(
        :profile_skill,
        profile:,
        description: "I'm good at welding.",
        master_skill: create(:master_skill, skill: "Welding", type: MasterSkill::SkillTypes::TECHNICAL)
      )

      create(
        :story,
        profile:,
        prompt: "Prompt",
        response: "Response"
      )

      tp = create(:training_provider, name: "Training Provider")
      create(
        :seeker_training_provider,
        user:,
        training_provider: tp,
        program: create(:program, name: "Program", training_provider: tp)
      )

      second_tp = create(:training_provider, name: "Second Training Provider")

      create(
        :seeker_training_provider,
        user:,
        training_provider: second_tp,
        program: nil
      )
    end

    it "returns the expanded profile" do
      expect(subject[:educationExperiences]).to contain_exactly({
                                                                  "id" => be_a(String),
                                                                  "organization_name" => "University of Cincinnati",
                                                                  "title" => "Student",
                                                                  "graduation_date" => "2019-05-01",
                                                                  "gpa" => "3.5",
                                                                  "activities" => "Activities"
                                                                })
      expect(subject[:industryInterests]).to contain_exactly("Manufacturing", "Healthcare")

      expect(subject[:otherExperiences]).to contain_exactly({
                                                              id: anything,
                                                              organizationName: "Turner Construction",
                                                              position: "Laborer",
                                                              startDate: "2015-01-01",
                                                              endDate: "2019-01-01",
                                                              isCurrent: false,
                                                              description: "Description"
                                                            })

      expect(subject[:personalExperience]).to contain_exactly({
                                                                id: anything,
                                                                activity: "Babysitting",
                                                                startDate: "2019-01-01",
                                                                endDate: "2020-01-01",
                                                                description: "I babysat for my neighbor's kids."
                                                              })

      expect(subject[:profileSkills]).to contain_exactly(
        {
          "id" => be_a(String),
          "description" => "I'm good at welding.",
          "masterSkill" => {
            "id" => be_a(String),
            "skill" => "Welding",
            "type" => MasterSkill::SkillTypes::TECHNICAL
          }
        }
      )

      expect(subject[:stories]).to contain_exactly(
        {
          id: anything,
          prompt: "Prompt",
          response: "Response"
        }
      )

      user = subject[:user]

      expect(user["id"]).to be_a(String)
      expect(user["email"]).to eq("seeker@blocktrainapp.com")
      expect(user["firstName"]).to eq("First")
      expect(user["lastName"]).to eq("Last")
      expect(user["phoneNumber"]).to eq("1234567890")
      expect(user["sub"]).to eq("sub")
      expect(user["zipCode"]).to eq("43210")

      stp = user["SeekerTrainingProvider"].select { |s| s["program"] }.first

      expect(stp["id"]).to be_a(String)
      expect(stp["trainingProvider"]["id"]).to be_a(String)
      expect(stp["trainingProvider"]["name"]).to eq("Training Provider")
      expect(stp["program"]["id"]).to be_a(String)
      expect(stp["program"]["name"]).to eq("Program")

      second_stp = user["SeekerTrainingProvider"].select { |s| s["program"].nil? }.first

      expect(second_stp["id"]).to be_a(String)
      expect(second_stp["trainingProvider"]["id"]).to be_a(String)
      expect(second_stp["trainingProvider"]["name"]).to eq("Second Training Provider")
      expect(second_stp["program"]).to be_nil

      expect(subject[:isProfileEditor]).to eq(true)
    end
  end

  describe "#update" do
    subject { described_class.new(profile, seeker).update(params) }

    let(:profile) { create(:profile, user:) }
    let(:seeker) { create(:seeker, user:) }
    let(:user) { create(:user) }

    let(:params) do
      {
        bio: "New Bio",
        met_career_coach:
      }
    end
    let(:met_career_coach) { profile.met_career_coach }

    it "updates the profile" do
      expect { subject }
        .to change { profile.reload.bio }.to("New Bio")
    end

    it "publishes a profile updated event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::SeekerUpdated::V1,
        aggregate_id: profile.user.id,
        data: Events::Common::UntypedHashWrapper.build(
          bio: "New Bio",
          met_career_coach: profile.met_career_coach,
          image: profile.image
        )
      ).and_call_original

      subject
    end

    context "when met_career_coach does not change" do
      it "does not publish a met career coach event" do
        expect(EventService).not_to receive(:create!).with(
          event_schema: Events::MetCareerCoachUpdated::V1,
          aggregate_id: profile.user.id,
          data: Events::Common::UntypedHashWrapper.build(
            met_career_coach:
          ),
          occurred_at: be_present
        )

        subject
      end
    end

    context "when met_career_coach changes" do
      let(:met_career_coach) { !profile.met_career_coach }

      it "creates an event" do
        allow(EventService).to receive(:create!)
        expect(EventService).to receive(:create!).with(
          event_schema: Events::MetCareerCoachUpdated::V1,
          aggregate_id: profile.user.id,
          data: Events::Common::UntypedHashWrapper.build(
            met_career_coach:
          )
        ).and_call_original

        subject
      end
    end
  end
end

class SeekerService
  include Cereal

  def initialize(profile, seeker)
    @profile = profile
    @seeker = seeker
  end

  def get(seeker_editor: false)
    industry_interests = profile.user.onboarding_session&.responses&.dig("opportunityInterests", "response") || []

    {
      **profile.as_json,
      desired_outcomes: [],
      educationExperiences: profile.education_experiences.map do |ee|
        ee.slice(:id, :organization_name, :title, :graduation_date, :gpa, :activities)
      end,
      hiringStatus: profile.hiring_status,
      industryInterests: industry_interests,
      isProfileEditor: seeker_editor,
      otherExperiences: profile.other_experiences.map do |oe|
        {
          id: oe.id,
          organizationName: oe.organization_name,
          position: oe.position,
          startDate: oe.start_date,
          endDate: oe.end_date,
          isCurrent: oe.is_current,
          description: oe.description
        }
      end,
      personalExperience: profile.personal_experiences.map do |pe|
        {
          id: pe.id,
          activity: pe.activity,
          startDate: pe.start_date,
          endDate: pe.end_date,
          description: pe.description
        }
      end,
      profileCertifications: [],
      professionalInterests: [],
      profileSkills: profile.profile_skills.map do |ps|
        {
          **ps.slice(:id, :description).as_json,
          "masterSkill" => ps.master_skill.slice(:id, :skill, :type).as_json
        }
      end,
      programs: [],
      reference: [],
      skills: [],
      stories: profile.stories.map { |s| s.slice(:id, :prompt, :response) },
      missingProfileItems: ProfileCompleteness.new(profile).status.missing,
      user: {
        **deep_transform_keys(profile.user.slice(:id, :email, :first_name, :last_name, :phone_number, :sub, :zip_code).as_json) { |key| to_camel_case(key) },
        "SeekerTrainingProvider" => profile.user.seeker_training_providers.map do |stp|
          {
            **stp.slice(:id, :program).as_json,
            trainingProvider: stp.training_provider.slice(:id, :name).as_json,
            program: stp&.program&.slice(:id, :name)&.as_json
          }
        end.as_json
      }
    }
  end

  def update(params)
    profile.update!(params)
    seeker&.update!(params.except(:met_career_coach))

    EventService.create!(
      event_schema: Events::SeekerUpdated::V1,
      aggregate_id: profile.user.id,
      data: Events::Common::UntypedHashWrapper.build(
        bio: profile.bio,
        met_career_coach: profile.met_career_coach,
        image: profile.image
      )
    )

    return unless profile.saved_change_to_met_career_coach?

    EventService.create!(
      event_schema: Events::MetCareerCoachUpdated::V1,
      aggregate_id: profile.user.id,
      data: Events::Common::UntypedHashWrapper.build(
        met_career_coach: profile.met_career_coach
      )
    )
  end

  private

  attr_reader :profile, :seeker
end

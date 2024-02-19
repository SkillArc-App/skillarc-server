class SeekerService
  include Cereal

  def initialize(seeker)
    @seeker = seeker
  end

  def get(user_id: nil, seeker_editor: false)
    industry_interests = seeker.user.onboarding_session&.responses&.dig("opportunityInterests", "response") || []

    if user_id.present? && user_id != seeker.user.id
      EventService.create!(
        event_schema: Events::SeekerViewed::V1,
        aggregate_id: user_id,
        data: Events::SeekerViewed::Data::V1.new(
          seeker_id: seeker.id
        )
      )
    end

    {
      **seeker.as_json,
      desired_outcomes: [],
      educationExperiences: seeker.education_experiences.map do |ee|
        ee.slice(:id, :organization_name, :title, :graduation_date, :gpa, :activities)
      end,
      hiringStatus: seeker.hiring_status,
      industryInterests: industry_interests,
      isProfileEditor: seeker_editor,
      otherExperiences: seeker.other_experiences.map do |oe|
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
      personalExperience: seeker.personal_experiences.map do |pe|
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
      profileSkills: seeker.profile_skills.map do |ps|
        {
          **ps.slice(:id, :description).as_json,
          "masterSkill" => ps.master_skill.slice(:id, :skill, :type).as_json
        }
      end,
      programs: [],
      reference: [],
      skills: [],
      stories: seeker.stories.map { |s| s.slice(:id, :prompt, :response) },
      missingProfileItems: ProfileCompleteness.new(seeker).status.missing,
      user: {
        **deep_transform_keys(seeker.user.slice(:id, :email, :first_name, :last_name, :phone_number, :sub, :zip_code).as_json) { |key| to_camel_case(key) },
        "SeekerTrainingProvider" => seeker.user.seeker_training_providers.map do |stp|
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
    # These are the only two attributes we accept now
    seeker.update!(params.slice(:bio, :image))

    EventService.create!(
      event_schema: Events::SeekerUpdated::V1,
      aggregate_id: seeker.user.id,
      data: Events::Common::UntypedHashWrapper.build(
        bio: seeker.bio,
        image: seeker.image
      )
    )

    return if params[:met_career_coach].nil?

    EventService.create!(
      event_schema: Events::MetCareerCoachUpdated::V1,
      aggregate_id: seeker.user.id,
      data: Events::Common::UntypedHashWrapper.build(
        met_career_coach: params[:met_career_coach]
      )
    )
  end

  private

  attr_reader :profile, :seeker
end

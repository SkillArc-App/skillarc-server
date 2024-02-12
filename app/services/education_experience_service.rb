class EducationExperienceService
  def initialize(profile, seeker)
    @profile = profile
    @seeker = seeker
  end

  def create(organization_name:, title: nil, graduation_date: nil, gpa: nil, activities: nil)
    ee = EducationExperience.create!(
      organization_name:,
      title:,
      graduation_date:,
      gpa:,
      activities:,
      id: SecureRandom.uuid,
      profile_id: profile.id,
      seeker_id: seeker.id
    )

    EventService.create!(
      event_schema: Events::EducationExperienceCreated::V1,
      aggregate_id: seeker.user.id,
      data: Events::EducationExperienceCreated::Data::V1.new(
        id: ee.id,
        organization_name:,
        title:,
        graduation_date:,
        gpa:,
        activities:,
        profile_id: profile.id,
        seeker_id: seeker.id
      ),
      occurred_at: Time.zone.now
    )
  end

  def update(id:, **params)
    education_experience = EducationExperience.find(id)

    education_experience.update!(**params)

    EventService.create!(
      event_schema: Events::EducationExperienceUpdated::V1,
      aggregate_id: seeker.user.id,
      data: Events::EducationExperienceUpdated::Data::V1.new(
        profile_id: profile.id,
        seeker_id: seeker.id,
        **params.merge(id:)
      ),
      occurred_at: Time.zone.now
    )
  end

  def destroy(id:)
    education_experience = EducationExperience.find(id)

    education_experience.destroy!

    EventService.create!(
      event_schema: Events::EducationExperienceDeleted::V1,
      aggregate_id: seeker.id,
      data: Events::Common::UntypedHashWrapper.build(
        id: education_experience.id
      ),
      occurred_at: Time.zone.now
    )
  end

  private

  attr_reader :profile, :seeker
end

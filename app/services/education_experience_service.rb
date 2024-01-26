class EducationExperienceService
  def initialize(profile, seeker)
    @profile = profile
    @seeker = seeker
  end

  def create(organization_name:, title: nil, graduation_date: nil, gpa: nil, activities: nil)
    EducationExperience.create!(
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
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_CREATED,
      aggregate_id: seeker.id,
      data: {
        organization_name:,
        title:,
        graduation_date:,
        gpa:,
        activities:
      },
      occurred_at: Time.zone.now
    )
  end

  def update(id:, **params)
    education_experience = EducationExperience.find(id)

    education_experience.update!(**params)

    EventService.create!(
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_UPDATED,
      aggregate_id: seeker.id,
      data: params.merge(id:),
      occurred_at: Time.zone.now
    )
  end

  def destroy(id:)
    education_experience = EducationExperience.find(id)

    education_experience.destroy!

    EventService.create!(
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_DELETED,
      aggregate_id: seeker.id,
      data: { id: education_experience.id },
      occurred_at: Time.zone.now
    )
  end

  private

  attr_reader :profile, :seeker
end

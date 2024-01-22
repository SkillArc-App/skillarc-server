class EducationExperienceService
  def initialize(profile)
    @profile = profile
  end

  def create(organization_name:, title: nil, graduation_date: nil, gpa: nil, activities: nil)
    EducationExperience.create!(
      organization_name: organization_name,
      title: title,
      graduation_date: graduation_date,
      gpa: gpa,
      activities: activities,
      id: SecureRandom.uuid,
      profile_id: profile.id
    )

    CreateEventJob.perform_later(
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_CREATED,
      aggregate_id: profile.id,
      data: {
        organization_name: organization_name,
        title: title,
        graduation_date: graduation_date,
        gpa: gpa,
        activities: activities
      },
      occurred_at: Time.zone.now,
    )
  end

  def update(id:, **params)
    education_experience = EducationExperience.find(id)

    education_experience.update!(**params)

    CreateEventJob.perform_later(
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_UPDATED,
      aggregate_id: profile.id,
      data: params.merge(id:),
      occurred_at: Time.zone.now,
    )
  end

  def destroy(id:)
    education_experience = EducationExperience.find(id)

    education_experience.destroy!

    CreateEventJob.perform_later(
      event_type: Event::EventTypes::EDUCATION_EXPERIENCE_DELETED,
      aggregate_id: profile.id,
      data: { id: education_experience.id },
      occurred_at: Time.zone.now,
    )
  end

  private

  attr_reader :profile
end
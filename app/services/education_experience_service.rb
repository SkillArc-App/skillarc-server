class EducationExperienceService
  include MessageEmitter

  def initialize(seeker)
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
      seeker_id: seeker.id
    )

    message_service.create!(
      schema: Events::EducationExperienceAdded::V1,
      seeker_id: seeker.id,
      data: {
        id: ee.id,
        organization_name:,
        title:,
        graduation_date:,
        gpa:,
        activities:
      }
    )
  end

  def update(id:, **)
    education_experience = EducationExperience.find(id)

    education_experience.update!(**)

    message_service.create!(
      schema: Events::EducationExperienceAdded::V1,
      seeker_id: seeker.id,
      data: {
        **,
        id:
      }
    )
  end

  def destroy(id:)
    education_experience = EducationExperience.find(id)

    education_experience.destroy!

    message_service.create!(
      schema: Events::EducationExperienceDeleted::V1,
      seeker_id: seeker.id,
      data: {
        id: education_experience.id
      },
      occurred_at: Time.zone.now
    )
  end

  private

  attr_reader :seeker
end

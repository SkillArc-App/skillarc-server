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
      schema: Events::EducationExperienceCreated::V1,
      user_id: seeker.user.id,
      data: Events::EducationExperienceCreated::Data::V1.new(
        id: ee.id,
        organization_name:,
        title:,
        graduation_date:,
        gpa:,
        activities:,
        seeker_id: seeker.id
      ),
      occurred_at: Time.zone.now
    )
  end

  def update(id:, **params)
    education_experience = EducationExperience.find(id)

    education_experience.update!(**params)

    message_service.create!(
      schema: Events::EducationExperienceUpdated::V1,
      user_id: seeker.user.id,
      data: Events::EducationExperienceUpdated::Data::V1.new(
        seeker_id: seeker.id,
        **params.merge(id:)
      ),
      occurred_at: Time.zone.now
    )
  end

  def destroy(id:)
    education_experience = EducationExperience.find(id)

    education_experience.destroy!

    message_service.create!(
      schema: Events::EducationExperienceDeleted::V1,
      seeker_id: seeker.id,
      data: Events::EducationExperienceDeleted::Data::V1.new(
        id: education_experience.id
      ),
      occurred_at: Time.zone.now
    )
  end

  private

  attr_reader :seeker
end

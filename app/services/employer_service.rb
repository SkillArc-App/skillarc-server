class EmployerService
  include MessageEmitter

  def create(params)
    e = Employer.create!(**params, id: SecureRandom.uuid)

    message_service.create!(
      schema: Events::EmployerCreated::V1,
      employer_id: e.id,
      data: {
        name: e.name,
        location: e.location,
        bio: e.bio,
        logo_url: e.logo_url
  }
    )

    e
  end

  def update(employer_id:, params:)
    e = Employer.find(employer_id)

    e.update!(**params)

    message_service.create!(
      schema: Events::EmployerUpdated::V1,
      employer_id: e.id,
      data: {
        name: e.name,
        location: e.location,
        bio: e.bio,
        logo_url: e.logo_url
  },
      occurred_at: e.updated_at
    )

    e
  end
end

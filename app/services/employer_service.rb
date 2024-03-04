class EmployerService
  def create(params)
    e = Employer.create!(**params, id: SecureRandom.uuid)

    EventService.create!(
      event_schema: Events::EmployerCreated::V1,
      employer_id: e.id,
      data: Events::EmployerCreated::Data::V1.new(
        name: e.name,
        location: e.location,
        bio: e.bio,
        logo_url: e.logo_url
      )
    )

    e
  end

  def update(employer_id:, params:)
    e = Employer.find(employer_id)

    e.update!(**params)

    EventService.create!(
      event_schema: Events::EmployerUpdated::V1,
      employer_id: e.id,
      data: Events::EmployerUpdated::Data::V1.new(
        name: e.name,
        location: e.location,
        bio: e.bio,
        logo_url: e.logo_url
      ),
      occurred_at: e.updated_at
    )

    e
  end
end

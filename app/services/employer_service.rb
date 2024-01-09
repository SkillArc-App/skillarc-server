class EmployerService
  def create(params)
    e = Employer.create!(**params, id: SecureRandom.uuid)

    CreateEventJob.perform_later(
      event_type: Event::EventTypes::EMPLOYER_CREATED,
      aggregate_id: e.id,
      data: {
        name: e.name,
        location: e.location,
        bio: e.bio,
        logo_url: e.logo_url
      },
      occurred_at: e.created_at,
      metadata: {}
    )

    e
  end

  def update(employer_id:, params:)
    e = Employer.find(employer_id)

    e.update!(**params)

    CreateEventJob.perform_later(
      event_type: Event::EventTypes::EMPLOYER_UPDATED,
      aggregate_id: e.id,
      data: {
        name: e.name,
        location: e.location,
        bio: e.bio,
        logo_url: e.logo_url
      },
      occurred_at: e.updated_at,
      metadata: {}
    )

    e
  end
end

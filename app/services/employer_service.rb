class EmployerService
  def create(params)
    e = Employer.create!(**params, id: SecureRandom.uuid)

    Resque.enqueue(
      CreateEventJob,
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
  end
end
class ProfileService
  def initialize(profile)
    @profile = profile
  end

  def update(params)
    profile.update!(params)

    if profile.saved_change_to_met_career_coach?
      Resque.enqueue(
        CreateEventJob,
        event_type: Event::EventTypes::MET_CAREER_COACH_UPDATED,
        aggregate_id: profile.user.id,
        data: {
          met_career_coach: profile.met_career_coach,
        },
        occurred_at: Time.now.utc,
        metadata: {}
      )
    end
  end

  private

  attr_reader :profile
end
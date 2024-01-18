class ProfileService
  def initialize(profile)
    @profile = profile
  end

  def update(params)
    profile.update!(params)

    EventService.create!(
      event_type: Event::EventTypes::PROFILE_UPDATED,
      aggregate_id: profile.user.id,
      data: {
        bio: profile.bio,
        met_career_coach: profile.met_career_coach,
        image: profile.image
      },
      occurred_at: Time.now.utc
    )

    return unless profile.saved_change_to_met_career_coach?

    EventService.create!(
      event_type: Event::EventTypes::MET_CAREER_COACH_UPDATED,
      aggregate_id: profile.user.id,
      data: {
        met_career_coach: profile.met_career_coach
      },
      occurred_at: Time.now.utc
    )
  end

  private

  attr_reader :profile
end

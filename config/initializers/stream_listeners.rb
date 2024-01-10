Rails.application.config.after_initialize do
  Pubsub.subscribe(
    event: Event::EventTypes::USER_CREATED,
    subscriber: Klayvio::UserSignup.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::USER_CREATED,
    subscriber: Slack::UserSignup.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::USER_UPDATED,
    subscriber: Klayvio::UserUpdated.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::MET_CAREER_COACH_UPDATED,
    subscriber: Klayvio::MetCareerCoachUpdated.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::NOTIFICATION_CREATED,
    subscriber: NotificationService.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::EDUCATION_EXPERIENCE_CREATED,
    subscriber: Klayvio::EducationExperienceEntered.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::EMPLOYER_INVITE_ACCEPTED,
    subscriber: Klayvio::EmployerInviteAccepted.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::EXPERIENCE_CREATED,
    subscriber: Klayvio::ExperienceEntered.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::ONBOARDING_COMPLETED,
    subscriber: Klayvio::OnboardingComplete.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::APPLICANT_STATUS_UPDATED,
    subscriber: Klayvio::ApplicationStatusUpdated.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::APPLICANT_STATUS_UPDATED,
    subscriber: Slack::UserApplied.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::CHAT_MESSAGE_SENT,
    subscriber: Klayvio::ChatMessageReceived.new
  )

  Pubsub.subscribe(
    event: Event::EventTypes::CHAT_MESSAGE_SENT,
    subscriber: Slack::ChatMessage.new
  )

  if Rails.env.production?
    job_freshness = DbStreamListener.new(JobFreshnessService, "job_freshness_service")
    coach_seeker = DbStreamListener.new(CoachSeekers, "coach_seekers")
    coaches = DbStreamListener.new(CoachesService, "coaches")

    Event::EventTypes::ALL.each do |event_type|
      Pubsub.subscribe(
        event: event_type,
        subscriber: job_freshness
      )

      Pubsub.subscribe(
        event: event_type,
        subscriber: coach_seeker
      )

      Pubsub.subscribe(
        event: event_type,
        subscriber: coaches
      )
    end
  else
    Event::EventTypes::ALL.each do |event_type|
      Pubsub.subscribe(
        event: event_type,
        subscriber: JobFreshnessService
      )

      Pubsub.subscribe(
        event: event_type,
        subscriber: CoachSeekers
      )

      Pubsub.subscribe(
        event: event_type,
        subscriber: CoachesService
      )
    end
  end
end

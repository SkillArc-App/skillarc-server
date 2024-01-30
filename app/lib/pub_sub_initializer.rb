module PubSubInitializer
  def self.run
    Pubsub.reset

    Pubsub.subscribe(
      event_schema: Events::UserCreated::V1,
      subscriber: Klayvio::UserSignup.new
    )

    Pubsub.subscribe(
      event_schema: Events::UserCreated::V1,
      subscriber: Slack::UserSignup.new
    )

    Pubsub.subscribe(
      event_schema: Events::UserUpdated::V1,
      subscriber: Klayvio::UserUpdated.new
    )

    Pubsub.subscribe(
      event_schema: Events::MetCareerCoachUpdated::V1,
      subscriber: Klayvio::MetCareerCoachUpdated.new
    )

    Pubsub.subscribe(
      event_schema: Events::NotificationCreated::V1,
      subscriber: NotificationService.new
    )

    Pubsub.subscribe(
      event_schema: Events::EducationExperienceCreated::V1,
      subscriber: Klayvio::EducationExperienceEntered.new
    )

    Pubsub.subscribe(
      event_schema: Events::EmployerInviteAccepted::V1,
      subscriber: Klayvio::EmployerInviteAccepted.new
    )

    Pubsub.subscribe(
      event_schema: Events::ExperienceCreated::V1,
      subscriber: Klayvio::ExperienceEntered.new
    )

    Pubsub.subscribe(
      event_schema: Events::OnboardingCompleted::V1,
      subscriber: Klayvio::OnboardingComplete.new
    )

    Pubsub.subscribe(
      event_schema: Events::ApplicantStatusUpdated::V1,
      subscriber: Klayvio::ApplicationStatusUpdated.new
    )

    Pubsub.subscribe(
      event_schema: Events::ApplicantStatusUpdated::V1,
      subscriber: Slack::UserApplied.new
    )

    Pubsub.subscribe(
      event_schema: Events::ChatMessageSent::V1,
      subscriber: Klayvio::ChatMessageReceived.new
    )

    Pubsub.subscribe(
      event_schema: Events::ChatMessageSent::V1,
      subscriber: Slack::ChatMessage.new
    )

    if Rails.env.production?
      job_freshness_subscriber = DbStreamListener.new(JobFreshnessService, "job_freshness_service")
      coach_seeker_subscriber = DbStreamListener.new(Coaches::SeekerService, "coach_seekers")
      coaches_subscriber = DbStreamListener.new(Coaches::CoachService, "coaches")
      barriers_subscriber = DbStreamListener.new(Coaches::BarrierService, "barriers")
    else
      job_freshness_subscriber = JobFreshnessService
      coach_seeker_subscriber = Coaches::SeekerService
      coaches_subscriber = Coaches::CoachService
      barriers_subscriber = Coaches::BarrierService
    end

    job_freshness_subscriber.handled_events.each do |event_schema|
      Pubsub.subscribe(
        event_schema:,
        subscriber: job_freshness_subscriber
      )
    end

    coach_seeker_subscriber.handled_events.each do |event_schema|
      Pubsub.subscribe(
        event_schema:,
        subscriber: coach_seeker_subscriber
      )
    end

    coaches_subscriber.handled_events.each do |event_schema|
      Pubsub.subscribe(
        event_schema:,
        subscriber: coaches_subscriber
      )
    end

    barriers_subscriber.handled_events.each do |event_schema|
      Pubsub.subscribe(
        event_schema:,
        subscriber: barriers_subscriber
      )
    end
  end
end

module PubSubInitializer
  def self.run
    PUBSUB.reset
    PUBSUB_SYNC.reset

    PUBSUB.subscribe(
      event_schema: Events::UserCreated::V1,
      subscriber: Klayvio::UserSignup.new
    )

    PUBSUB.subscribe(
      event_schema: Events::UserCreated::V1,
      subscriber: Slack::UserSignup.new
    )

    PUBSUB.subscribe(
      event_schema: Events::UserUpdated::V1,
      subscriber: Klayvio::UserUpdated.new
    )

    PUBSUB.subscribe(
      event_schema: Events::MetCareerCoachUpdated::V1,
      subscriber: Klayvio::MetCareerCoachUpdated.new
    )

    PUBSUB.subscribe(
      event_schema: Events::NotificationCreated::V1,
      subscriber: NotificationService.new
    )

    PUBSUB.subscribe(
      event_schema: Events::EducationExperienceCreated::V1,
      subscriber: Klayvio::EducationExperienceEntered.new
    )

    PUBSUB.subscribe(
      event_schema: Events::EmployerInviteAccepted::V1,
      subscriber: Klayvio::EmployerInviteAccepted.new
    )

    PUBSUB.subscribe(
      event_schema: Events::ExperienceCreated::V1,
      subscriber: Klayvio::ExperienceEntered.new
    )

    PUBSUB.subscribe(
      event_schema: Events::OnboardingCompleted::V1,
      subscriber: Klayvio::OnboardingComplete.new
    )

    PUBSUB.subscribe(
      event_schema: Events::ApplicantStatusUpdated::V1,
      subscriber: Klayvio::ApplicationStatusUpdated.new
    )

    PUBSUB.subscribe(
      event_schema: Events::ApplicantStatusUpdated::V1,
      subscriber: Slack::UserApplied.new
    )

    PUBSUB.subscribe(
      event_schema: Events::ChatMessageSent::V1,
      subscriber: Klayvio::ChatMessageReceived.new
    )

    PUBSUB.subscribe(
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

    [
      job_freshness_subscriber,
      coach_seeker_subscriber,
      coaches_subscriber,
      barriers_subscriber
    ].each do |subscriber|
      subscriber.handled_events.each do |event_schema|
        PUBSUB.subscribe(
          event_schema:,
          subscriber:
        )
      end

      subscriber.handled_events_sync.each do |event_schema|
        PUBSUB_SYNC.subscribe(
          event_schema:,
          subscriber:
        )
      end
    end
  end
end

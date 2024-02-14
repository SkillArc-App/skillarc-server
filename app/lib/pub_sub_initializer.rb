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
      event_schema: Events::ApplicantStatusUpdated::V2,
      subscriber: Klayvio::ApplicationStatusUpdated.new
    )

    PUBSUB.subscribe(
      event_schema: Events::ApplicantStatusUpdated::V2,
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

    [
      DbStreamListener.build(JobFreshnessService, "job_freshness_service"),
      DbStreamListener.build(Coaches::SeekerService, "coach_seekers"),
      DbStreamListener.build(Coaches::CoachService, "coaches"),
      DbStreamListener.build(Coaches::BarrierService, "barriers"),
      DbStreamListener.build(Coaches::JobService, "coaches_jobs"),
      DbStreamListener.build(Coaches::RecommendationService, "coaches_recommendations")
    ].each do |listener|
      listener.handled_events.each do |event_schema|
        PUBSUB.subscribe(
          event_schema:,
          subscriber: listener
        )
      end

      listener.handled_events_sync.each do |event_schema|
        PUBSUB_SYNC.subscribe(
          event_schema:,
          subscriber: listener
        )
      end

      # Only kick off jobs from the server
      PlayStreamJob.perform_later(listener_name: listener.listener_name) if ENV['RUN_ENVIRONMENT'] == 'server'
    end
  end
end

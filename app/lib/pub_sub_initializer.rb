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
      event_schema: Events::ApplicantStatusUpdated::V5,
      subscriber: Klayvio::ApplicationStatusUpdated.new
    )

    PUBSUB.subscribe(
      event_schema: Events::ApplicantStatusUpdated::V5,
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

    all_schemas = EventService.all_schemas

    [
      DbStreamAggregator.build(Coaches::SeekerService.new, "coach_seekers"),
      DbStreamAggregator.build(Coaches::CoachService.new, "coaches"),
      DbStreamAggregator.build(Coaches::BarrierService.new, "barriers"),
      DbStreamAggregator.build(Coaches::JobService.new, "coaches_jobs"),
      DbStreamReactor.build(Contact::SmsService.new, "contact_sms"),
      DbStreamReactor.build(Contact::SmtpService.new, "contact_smtp"),
      DbStreamReactor.build(Coaches::RecommendationService.new, "coaches_recommendations"),
      DbStreamAggregator.build(Employers::EmployerService.new, "employers"),
      DbStreamAggregator.build(Employers::ApplicationNotificationService.new, "employers_application_notification_service"),
      DbStreamReactor.build(Employers::WeeklyUpdateService.new, "employers_weekly_update_service"),
      DbStreamAggregator.build(Seekers::SeekerService.new, "seekers")
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

      (all_schemas - listener.all_handled_events).each do |event_schema|
        PUBSUB.subscribe(
          event_schema:,
          subscriber: listener
        )
      end

      # Only kick off jobs from the server
      PlayStreamJob.perform_later(listener_name: listener.listener_name) if ENV['RUN_ENVIRONMENT'] == 'server'
    end
  end
end

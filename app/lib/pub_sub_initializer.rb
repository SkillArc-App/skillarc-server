module PubSubInitializer
  def self.run
    PUBSUB.reset
    PUBSUB_SYNC.reset

    PUBSUB.subscribe(
      message_schema: Events::UserCreated::V1,
      subscriber: Klayvio::UserSignup.new
    )

    PUBSUB.subscribe(
      message_schema: Events::UserCreated::V1,
      subscriber: Slack::UserSignup.new
    )

    PUBSUB.subscribe(
      message_schema: Events::UserUpdated::V1,
      subscriber: Klayvio::UserUpdated.new
    )

    PUBSUB.subscribe(
      message_schema: Events::MetCareerCoachUpdated::V1,
      subscriber: Klayvio::MetCareerCoachUpdated.new
    )

    PUBSUB.subscribe(
      message_schema: Events::NotificationCreated::V1,
      subscriber: NotificationService.new
    )

    PUBSUB.subscribe(
      message_schema: Events::EducationExperienceCreated::V1,
      subscriber: Klayvio::EducationExperienceEntered.new
    )

    PUBSUB.subscribe(
      message_schema: Events::EmployerInviteAccepted::V1,
      subscriber: Klayvio::EmployerInviteAccepted.new
    )

    PUBSUB.subscribe(
      message_schema: Events::ExperienceCreated::V1,
      subscriber: Klayvio::ExperienceEntered.new
    )

    PUBSUB.subscribe(
      message_schema: Events::OnboardingCompleted::V1,
      subscriber: Klayvio::OnboardingComplete.new
    )

    PUBSUB.subscribe(
      message_schema: Events::ApplicantStatusUpdated::V5,
      subscriber: Klayvio::ApplicationStatusUpdated.new
    )

    PUBSUB.subscribe(
      message_schema: Events::ApplicantStatusUpdated::V5,
      subscriber: Slack::UserApplied.new
    )

    PUBSUB.subscribe(
      message_schema: Events::ChatMessageSent::V1,
      subscriber: Klayvio::ChatMessageReceived.new
    )

    PUBSUB.subscribe(
      message_schema: Events::ChatMessageSent::V1,
      subscriber: Slack::ChatMessage.new
    )

    all_schemas = MessageService.all_schemas

    [
      DbStreamAggregator.build(Coaches::SeekerService.new, "coach_seekers"),
      DbStreamAggregator.build(Search::SearchService.new, "search"),
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
      listener.handled_messages.each do |message_schema|
        PUBSUB.subscribe(
          message_schema:,
          subscriber: listener
        )
      end

      listener.handled_messages_sync.each do |message_schema|
        PUBSUB_SYNC.subscribe(
          message_schema:,
          subscriber: listener
        )
      end

      (all_schemas - listener.all_handled_messages).each do |message_schema|
        PUBSUB.subscribe(
          message_schema:,
          subscriber: listener
        )
      end
    end
  end
end

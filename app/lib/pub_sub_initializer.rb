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
      DbStreamAggregator.build(consumer: Coaches::SeekerAggregator.new, listener_name: "coach_seekers"),
      DbStreamReactor.build(consumer: Coaches::SeekerReactor.new, listener_name: "coach_seekers_reactor"),
      DbStreamReactor.build(consumer: Applicants::OrchestrationService.new, listener_name: "applicants_orchestration_service"),
      DbStreamAggregator.build(consumer: Search::SearchService.new, listener_name: "search"),
      DbStreamAggregator.build(consumer: Coaches::CoachService.new, listener_name: "coaches"),
      DbStreamAggregator.build(consumer: Coaches::BarrierService.new, listener_name: "barriers"),
      DbStreamAggregator.build(consumer: Coaches::JobService.new, listener_name: "coaches_jobs"),
      DbStreamReactor.build(consumer: Contact::SmsService.new, listener_name: "contact_sms"),
      DbStreamReactor.build(consumer: Contact::SmtpService.new, listener_name: "contact_smtp"),
      DbStreamReactor.build(consumer: Coaches::RecommendationService.new, listener_name: "coaches_recommendations"),
      DbStreamReactor.build(consumer: Contact::CalDotCom::SchedulingReactor.new, listener_name: "cal_com_scheduling"),
      DbStreamAggregator.build(consumer: Employers::EmployerService.new, listener_name: "employers"),
      DbStreamAggregator.build(consumer: Employers::ApplicationNotificationService.new, listener_name: "employers_application_notification_service"),
      DbStreamReactor.build(consumer: Employers::WeeklyUpdateService.new, listener_name: "employers_weekly_update_service"),
      DbStreamAggregator.build(consumer: Seekers::SeekerService.new, listener_name: "seekers")
    ].each do |listener|
      listener.handled_messages_sync.each do |message_schema|
        PUBSUB_SYNC.subscribe(
          message_schema:,
          subscriber: listener
        )
      end

      (all_schemas - listener.handled_messages_sync).each do |message_schema|
        PUBSUB.subscribe(
          message_schema:,
          subscriber: listener
        )
      end
    end
  end
end

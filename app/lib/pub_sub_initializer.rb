module PubSubInitializer
  def self.run
    PUBSUB.reset
    PUBSUB_SYNC.reset

    PUBSUB.subscribe(
      message_schema: Events::UserCreated::V1,
      subscriber: Klayvio::UserSignup.new
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
      message_schema: Events::EducationExperienceAdded::V1,
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
      message_schema: Events::ApplicantStatusUpdated::V6,
      subscriber: Klayvio::ApplicationStatusUpdated.new
    )

    PUBSUB.subscribe(
      message_schema: Events::ChatMessageSent::V1,
      subscriber: Klayvio::ChatMessageReceived.new
    )

    aggregators = [
      DbStreamAggregator.build(consumer: Analytics::AnalyticsAggregator.new, listener_name: "analytics"),
      DbStreamAggregator.build(consumer: Attributes::AttributesAggregator.new, listener_name: "attributes_aggregator"),
      DbStreamAggregator.build(consumer: Coaches::CoachesAggregator.new, listener_name: "coach_seekers"),
      DbStreamAggregator.build(consumer: Jobs::JobsAggregator.new, listener_name: "jobs_aggregator"),
      DbStreamAggregator.build(consumer: Search::SearchService.new, listener_name: "search"),
      DbStreamAggregator.build(consumer: Seekers::SeekerAggregator.new, listener_name: "seeker_aggregator"),
      DbStreamAggregator.build(consumer: Contact::ContactAggregator.new, listener_name: "contact_aggregator"),
      DbStreamAggregator.build(consumer: Infrastructure::InfrastructureAggregator.new, listener_name: "infrastructure_aggregator"),
      DbStreamAggregator.build(consumer: Employers::EmployerAggregator.new, listener_name: "employers"),
      DbStreamAggregator.build(consumer: Seekers::SeekerService.new, listener_name: "seekers")
    ]

    reactors = [
      DbStreamReactor.build(consumer: Coaches::CoachesReactor.new, listener_name: "coach_seekers_reactor"),
      DbStreamReactor.build(consumer: Applicants::OrchestrationReactor.new, listener_name: "applicants_orchestration_reactor"),
      DbStreamReactor.build(consumer: Attributes::AttributesReactor.new, listener_name: "attributes_reactor"),
      DbStreamReactor.build(consumer: Jobs::JobsReactor.new, listener_name: "jobs_reactor"),
      DbStreamReactor.build(consumer: Slack::SlackReactor.new, listener_name: "slack_reactor"),
      DbStreamReactor.build(consumer: Contact::ContactReactor.new, listener_name: "contact_reactor"),
      DbStreamReactor.build(consumer: Seekers::SeekerReactor.new, listener_name: "seeker_reactor"),
      DbStreamReactor.build(consumer: Infrastructure::InfrastructureReactor.new, listener_name: "infrastructure_reactor"),
      DbStreamReactor.build(consumer: Contact::SmsReactor.new, listener_name: "contact_sms"),
      DbStreamReactor.build(consumer: Contact::SmtpReactor.new, listener_name: "contact_smtp"),
      DbStreamReactor.build(consumer: Contact::CalDotCom::SchedulingReactor.new, listener_name: "cal_com_scheduling"),
      DbStreamReactor.build(consumer: Employers::EmployerReactor.new, listener_name: "employers_application_notification_service")
    ]

    (aggregators + reactors).each do |listener|
      listener.handled_messages_sync.each do |message_schema|
        PUBSUB_SYNC.subscribe(
          message_schema:,
          subscriber: listener
        )
      end

      listener.handled_messages.each do |message_schema|
        PUBSUB.subscribe(
          message_schema:,
          subscriber: listener
        )
      end
    end
  end
end

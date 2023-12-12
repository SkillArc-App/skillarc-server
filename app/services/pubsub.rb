class Pubsub
  def self.publish(event:)
    subscribers[event.event_type]&.each do |subscriber|
      subscriber.call(event: event)
    end
  end

  def self.subscribe(event:, subscriber:)
    subscribers[event] ||= []
    subscribers[event] << subscriber
  end

  private

  def self.subscribers
    @subscribers ||= {}
  end
end

# TODO: Move this to a config file
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

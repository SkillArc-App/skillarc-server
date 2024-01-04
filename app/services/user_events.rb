class UserEvents
  def initialize(user)
    @user = user
  end

  def all
    events = Event.where(aggregate_id: user.id).order(occurred_at: :desc)

    applicant_events = Event.where(event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED)
                            .where("data->>'user_id' = ?", user.id)

    (events + applicant_events).sort_by(&:occurred_at).reverse.map do |event|
      event_message = event_message(event)

      next unless event_message

      {
        datetime: event.occurred_at.in_time_zone('Eastern Time (US & Canada)').strftime("%Y-%m-%d %l:%M%p"),
        event_message:
      }
    end.compact
  end

  private

  def event_message(event)
    case event.event_type
    when Event::EventTypes::APPLICANT_STATUS_UPDATED
      "Applicant Status Updated: #{event.data['employment_title']} - #{event.data['status']}"
    when Event::EventTypes::EDUCATION_EXPERIENCE_CREATED
      "Education Experience Created: #{event.data['organization_name']}"
    when Event::EventTypes::EXPERIENCE_CREATED
      "Work Experience Created: #{event.data['organization_name']}"
    when Event::EventTypes::JOB_SAVED
      "Job Saved: #{event.data['employment_title']}"
    when Event::EventTypes::ONBOARDING_COMPLETED
      "Onboarding Complete"
    when Event::EventTypes::USER_CREATED
      "Signed Up"
    end
  end

  attr_reader :user
end

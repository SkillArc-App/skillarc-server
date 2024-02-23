class UserEvents
  def initialize(user)
    @user = user
  end

  def all
    events = Event.where(aggregate_id: user.id).order(occurred_at: :desc).map(&:message)

    applicant_events = Event.where(event_type: Messages::Types::APPLICANT_STATUS_UPDATED)
                            .where("data->>'user_id' = ?", user.id)
                            .map(&:message)

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

  def event_message(message)
    case message.event_type
    when Messages::Types::APPLICANT_STATUS_UPDATED
      "Applicant Status Updated: #{message.data[:employment_title]} - #{message.data[:status]}"
    when Messages::Types::EDUCATION_EXPERIENCE_CREATED
      "Education Experience Created: #{message.data[:organization_name]}"
    when Messages::Types::EXPERIENCE_CREATED
      "Work Experience Created: #{message.data[:organization_name]}"
    when Messages::Types::JOB_SAVED
      "Job Saved: #{message.data[:employment_title]}"
    when Messages::Types::ONBOARDING_COMPLETED
      "Onboarding Complete"
    when Messages::Types::USER_CREATED
      "Signed Up"
    end
  end

  attr_reader :user
end

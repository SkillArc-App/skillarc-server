class UserEvents
  def initialize(user)
    @user = user
  end

  def all
    user_messages = MessageService.aggregate_events(Aggregates::User.new(user_id: user.id))
    person_messages = if user.person_id.present?
                        MessageService.aggregate_events(Aggregates::Person.new(person_id: user.person_id))
                      else
                        []
                      end

    applicant_messages = Events::ApplicantStatusUpdated::V6.all_messages.select { |m| m.data.user_id == user.id }

    messages = user_messages + person_messages + applicant_messages

    messages.sort_by(&:occurred_at).reverse.map do |event|
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
    case message.schema
    when Events::ApplicantStatusUpdated::V6
      "Applicant Status Updated: #{message.data.employment_title} - #{message.data.status}"
    when Events::EducationExperienceAdded::V2
      "Education Experience Created: #{message.data.organization_name}"
    when Events::ExperienceAdded::V2
      "Work Experience Created: #{message.data.organization_name}"
    when Events::JobSaved::V1
      "Job Saved: #{message.data.employment_title}"
    when Events::OnboardingCompleted::V3
      "Onboarding Complete"
    when Events::UserCreated::V1
      "Signed Up"
    end
  end

  attr_reader :user
end

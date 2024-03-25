module Coaches
  class FeedAggregator < MessageConsumer
    def reset_for_replay
      FeedEvent.delete_all
    end

    on_message Events::ApplicantStatusUpdated::V5 do |message|
      first_name = message.data.applicant_first_name
      last_name = message.data.applicant_last_name
      email = message.data.applicant_email
      status = message.data.status

      context = Coaches::CoachSeekerContext.find_by!(user_id: message.data.user_id)

      FeedEvent.create!(
        context_id: context.context_id,
        occurred_at: message.occurred_at,
        seeker_email: email,
        description:
          "#{first_name} #{last_name}'s application for #{message.data.employment_title} at #{message.data.employer_name} has been updated to #{status}."
      )
    end
  end
end

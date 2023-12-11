module Klayvio
  class ChatMessageSent
    def call(event:)
      applicant = Applicant.find(event.data["applicant_id"])
      user = User.find(event.data["user_id"])

      Klayvio.new.chat_message_sent(
        applicant_id: event.data["applicant_id"],
        email: user.email,
        employment_title: applicant.job.employment_title,
        employer_name: applicant.job.employer.name,
        event_id: event.id,
        occurred_at: event.occurred_at,
        profile_id: event.data["profile_id"],
      )
    end
  end
end

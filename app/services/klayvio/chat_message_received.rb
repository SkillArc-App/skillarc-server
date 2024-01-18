module Klayvio
  class ChatMessageReceived
    def call(event:)
      applicant = Applicant.find(event.data[:applicant_id])
      recipient_user = applicant.profile.user

      user = User.find(event.data[:from_user_id])

      return if user == recipient_user

      Klayvio.new.chat_message_received(
        applicant_id: event.data[:applicant_id],
        email: recipient_user.email,
        employment_title: applicant.job.employment_title,
        employer_name: applicant.job.employer.name,
        event_id: event.id,
        occurred_at: event.occurred_at
      )
    end
  end
end

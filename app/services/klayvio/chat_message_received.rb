module Klayvio
  class ChatMessageReceived
    include DefaultStreamId

    def call(message:)
      applicant = Applicant.find(message.data[:applicant_id])
      recipient_user = applicant.seeker.user

      user = User.find(message.data[:from_user_id])

      return if user == recipient_user

      Gateway.build.chat_message_received(
        applicant_id: message.data[:applicant_id],
        email: recipient_user.email,
        employment_title: applicant.job.employment_title,
        employer_name: applicant.job.employer.name,
        event_id: message.id,
        occurred_at: message.occurred_at
      )
    end
  end
end

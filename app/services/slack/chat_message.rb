module Slack
  class ChatMessage < SlackNotifier
    include DefaultStreamId

    def call(message:)
      applicant = Applicant.find(message.data[:applicant_id])
      profile = applicant.profile

      from_user_id = message.data[:from_user_id]

      job = applicant.job

      message = if applicant.profile.user.id == from_user_id
                  "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{profile.id}|#{profile.user.email}> has *sent* a message to *#{job.employer.name}* for their applcation to *#{job.employment_title}*."
                else
                  "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{profile.id}|#{profile.user.email}> has *received* a message from *#{job.employer.name}* for their applcation to *#{job.employment_title}*."
                end

      notifier.ping(message)
    end
  end
end

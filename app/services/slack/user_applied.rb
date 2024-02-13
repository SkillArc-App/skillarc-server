module Slack
  class UserApplied < SlackNotifier
    include DefaultStreamId

    def call(message:)
      return unless message.data[:status] == "new"

      applicant = Applicant.find(message.data[:applicant_id])
      user = applicant.seeker.user

      notifier.ping(
        "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{user.seeker.id}|#{user.email}> has applied to *#{applicant.job.employment_title}* at *#{applicant.job.employer.name}*"
      )
    end
  end
end

module Slack
  class UserApplied < SlackNotifier
    def call(event:)
      return unless event.data["status"] == "new"

      applicant = Applicant.find(event.data["applicant_id"])
      user = applicant.profile.user

      notifier.ping(
        "<#{ENV['FRONTEND_URL']}/profiles/#{user.profile.id}|#{user.email}> has applied to *#{applicant.job.employment_title}* at *#{applicant.job.employer.name}*"
      )
    end
  end
end

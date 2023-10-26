module Slack
  class UserApplied
    def call(event:)
      return unless event.data["status"] == "new"

      applicant = Applicant.find(event.data["applicant_id"])
      user = applicant.profile.user

      notifer = Gateway.build

      notifer.ping(
        "<#{ENV['FRONTEND_URL']}/profiles/#{user.profile.id}|#{user.email}> has applied to *#{applicant.job.employment_title}* at *#{applicant.job.employer.name}*"
      )
    end
  end
end
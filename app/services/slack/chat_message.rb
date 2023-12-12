module Slack
  class ChatMessage < SlackNotifier
    def call(event:)
      applicant = Applicant.find(event.data["applicant_id"])
      profile = applicant.profile

      from_user_id = event.data["from_user_id"]

      job = applicant.job

      message = applicant.profile.user.id == from_user_id ?
        "Applicant <#{ENV['FRONTEND_URL']}/profiles/#{profile.id}|hannah@blocktrainapp.com> has *sent* a message to *#{job.employer.name}* for their applcation to *#{job.employment_title}*."
        : "Applicant <#{ENV['FRONTEND_URL']}/profiles/#{profile.id}|#{profile.user.email}> has *received* a message from *#{job.employer.name}* for their applcation to *#{job.employment_title}*."

      notifier.ping(message)
    end
  end
end

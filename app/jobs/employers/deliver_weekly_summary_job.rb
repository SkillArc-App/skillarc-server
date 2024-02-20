module Employers
  class DeliverWeeklySummaryJob < ApplicationJob
    queue_as :default

    def perform(new_applicants:, pending_applicants:, employer:, recruiter:)
      Contact::SmtpService.new.send_weekly_employer_update(
        new_applicants:,
        pending_applicants:,
        employer:,
        recruiter:
      )
    end
  end
end

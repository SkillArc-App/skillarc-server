module Employers
  class WeeklyUpdateService < EventConsumer
    def self.handled_events
      [Events::DayElapsed::V1].freeze
    end

    def self.handle_event(message, with_side_effects: true)
      case message.event_schema
      when Events::DayElapsed::V1
        handle_day_elapsed(message, with_side_effects:)
      end
    end

    def self.reset_for_replay; end

    def self.handle_day_elapsed(message, with_side_effects: true)
      return unless with_side_effects

      date = message.data.date
      day_of_week = date.strftime("%A").downcase

      return unless day_of_week == Events::DayElapsed::Data::DaysOfWeek::TUESDAY

      Employer.find_each do |employer|
        employer.recruiters.each do |recruiter|
          new_applicants = employer.applicants.active.where("status_as_of >= ?", date - 1.week)
          pending_applicants = employer.applicants.active.where("status_as_of < ?", date - 1.week)

          Contact::SmtpService.new.send_weekly_employer_update(
            new_applicants:,
            pending_applicants:,
            employer:,
            recruiter:
          )
        end
      end
    end
  end
end

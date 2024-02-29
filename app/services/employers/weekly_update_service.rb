module Employers
  class WeeklyUpdateService < EventConsumer
    def handled_events
      [Events::DayElapsed::V1].freeze
    end

    def handle_message(message)
      case message.schema
      when Events::DayElapsed::V1
        handle_day_elapsed(message)
      end
    end

    def reset_for_replay; end

    private

    def handle_day_elapsed(message)
      date = message.data.date
      day_of_week = date.strftime("%A").downcase

      return unless day_of_week == Events::DayElapsed::Data::DaysOfWeek::TUESDAY

      Employer.find_each do |employer|
        next unless employer.active?

        new_applicants = employer.applicants.active.where("status_as_of >= ?", date - 1.week).map do |applicant|
          Commands::SendWeeklyEmployerUpdate::SummaryApplicant::V1.new(
            first_name: applicant.first_name,
            last_name: applicant.last_name,
            certified_by: Seeker.find_by(seeker_id: applicant.seeker_id)&.certified_by
          )
        end

        pending_applicants = employer.applicants.active.where("status_as_of < ?", date - 1.week).map do |applicant|
          Commands::SendWeeklyEmployerUpdate::SummaryApplicant::V1.new(
            first_name: applicant.first_name,
            last_name: applicant.last_name,
            certified_by: Seeker.find_by(seeker_id: applicant.seeker_id)&.certified_by
          )
        end

        employer.recruiters.each do |recruiter|
          CommandService.create!(
            command_schema: Commands::SendWeeklyEmployerUpdate::V1,
            aggregate_id: employer.id,
            trace_id: SecureRandom.uuid,
            data: Commands::SendWeeklyEmployerUpdate::Data::V1.new(
              employer_name: employer.name,
              recepent_email: recruiter.email,
              new_applicants:,
              pending_applicants:
            )
          )
        end
      end
    end
  end
end

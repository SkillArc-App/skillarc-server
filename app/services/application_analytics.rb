class ApplicationAnalytics
  def average_status_times
    times = Applicant.all.map do |applicant|
      statuses = applicant.applicant_statuses
      statuses.count.times.map do |i|
        status = statuses[i]
        next_status = statuses[i + 1]

        next_time = next_status ? next_status.created_at : Time.now

        days = (next_time - status.created_at).to_i / 1.day
        hours = ((next_time - status.created_at) - days.days).to_i / 1.hour

        {
          status: status.status,
          time: {
            days: days,
            hours: hours
          }
        }
      end
    end.flatten

    times.group_by { |time| time[:status] }.map do |status, times|
      total_days = times.map { |time| time[:time][:days] }.sum / times.count.to_f
      total_hours = times.map { |time| time[:time][:hours] }.sum / times.count.to_f

      days = total_days.floor
      hours = (total_days * 24 + total_hours) % 24

      {
        status: status,
        time: {
          days: days,
          hours: hours
        }
      }
    end
  end

  def current_status_times
    Applicant.all.includes(profile: :user).map do |applicant|
      status = applicant.applicant_statuses.last_created

      days = (Time.now - status.created_at).to_i / 1.day
      hours = ((Time.now - status.created_at) - days.days).to_i / 1.hour

      user = applicant.profile.user

      {
        id: applicant.id,
        applicant_name: "#{user.first_name} #{user.last_name}",
        employment_title: applicant.job.employment_title,
        employer_name: applicant.job.employer.name,
        status: status.status,
        time: {
          days: days,
          hours: hours
        }
      }
    end
  end
end
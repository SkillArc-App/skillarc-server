class ApplicationAnalytics
  def average_status_times
    times = filtered_applicants.map do |applicant|
      statuses = applicant.applicant_statuses
      statuses.count.times.map do |i|
        status = statuses[i]
        next_status = statuses[i + 1]

        next_time = next_status ? next_status.created_at : Time.zone.now

        days = (next_time - status.created_at).to_i / 1.day
        hours = ((next_time - status.created_at) - days.days).to_i / 1.hour

        {
          status: status.status,
          time: {
            days:,
            hours:
          }
        }
      end
    end.flatten

    times.group_by { |time| time[:status] }.map do |status, times_for_status|
      total_days = times_for_status.map { |time| time[:time][:days] }.sum / times_for_status.count.to_f
      total_hours = times_for_status.map { |time| time[:time][:hours] }.sum / times_for_status.count.to_f

      days = total_days.floor
      hours = (total_days * 24 + total_hours) % 24

      {
        status:,
        time: {
          days:,
          hours:
        }
      }
    end
  end

  def current_status_times
    filtered_applicants.map do |applicant|
      status = applicant.applicant_statuses.last_created

      days = (Time.zone.now - status.created_at).to_i / 1.day
      hours = ((Time.zone.now - status.created_at) - days.days).to_i / 1.hour

      user = applicant.profile.user

      {
        id: applicant.id,
        applicant_name: "#{user.first_name} #{user.last_name}",
        employment_title: applicant.job.employment_title,
        employer_name: applicant.job.employer.name,
        status: status.status,
        time: {
          days:,
          hours:
        }
      }
    end
  end

  def persist_current_status_times
    ApplicantAnalytic.delete_all

    a = current_status_times.map do |current_status_time|
      applicant = Applicant.find(current_status_time[:id])

      {
        applicant_id: applicant.id,
        applicant_created_at: applicant.created_at,
        job_id: applicant.job.id,
        employer_id: applicant.job.employer.id,
        employer_name: applicant.job.employer.name,
        employment_title: applicant.job.employment_title,
        applicant_name: "#{applicant.profile.user.first_name} #{applicant.profile.user.last_name}",
        applicant_email: applicant.profile.user.email,
        status: current_status_time[:status],
        days: current_status_time[:time][:days],
        hours: current_status_time[:time][:hours]
      }
    end

    ApplicantAnalytic.create(a)
  end

  private

  def filtered_applicants
    Applicant.where.not(job_id: Job.where(hide_job: true).pluck(:id)).includes(profile: :user)
  end
end

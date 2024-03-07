module Employers
  class ApplicantService
    def initialize(employers:)
      @employers = employers
    end

    def all
      jobs = employers.map(&:jobs).flatten
      applicants = Applicant.includes(:applicant_status_reasons).where(job: jobs)
      seekers = Seeker.where(seeker_id: applicants.select(:seeker_id))

      Applicant.includes(:job, :applicant_status_reasons).where(job: jobs).map do |a|
        next if a.certified_by.nil? && a.job.staffing?

        {
          id: a.applicant_id,
          job_id: a.job.id,
          chat_enabled: true,
          certified_by: seekers.detect { |s| s.seeker_id == a.seeker_id }&.certified_by,
          created_at: a.created_at,
          job_name: a.job.employment_title,
          first_name: a.first_name,
          last_name: a.last_name,
          email: a.email,
          phone_number: a.phone_number,
          profile_link: "/profiles/#{a.seeker_id}",
          programs: [], # TODO
          status: a.status,
          status_reasons: a.applicant_status_reasons.map(&:reason)
        }
      end.compact
    end

    private

    attr_reader :employers
  end
end

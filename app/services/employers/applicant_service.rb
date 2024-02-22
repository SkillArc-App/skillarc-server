module Employers
  class ApplicantService
    def initialize(employers:)
      @employers = employers
    end

    def all
      jobs = employers.map(&:jobs).flatten

      Applicant.where(job: jobs).map do |a|
        {
          id: a.id,
          job_id: a.job.id,
          chat_enabled: true,
          created_at: a.created_at,
          job_name: a.job.employment_title,
          first_name: a.first_name,
          last_name: a.last_name,
          email: a.email,
          phone_number: a.phone_number,
          profile_link: "/profiles/#{a.seeker_id}",
          programs: [], # TODO
          status: a.status,
          status_reasons: [] # TODO
        }
      end
    end

    private

    attr_reader :employers
  end
end

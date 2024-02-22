module Employers
  class JobService
    def initialize(employers:)
      @employers = employers
    end

    def all
      Job.where(employer: employers).map do |job|
        {
          id: job.id,
          employer_id: job.employer.id,
          employment_title: job.employment_title,
          employer_name: job.employer.name,
          description: "descriptions don't exist yet"
        }
      end
    end

    private

    attr_reader :employers
  end
end

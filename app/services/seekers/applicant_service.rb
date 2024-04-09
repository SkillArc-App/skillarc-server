module Seekers
  class ApplicantService
    include MessageEmitter

    def initialize(seeker)
      @seeker = seeker
    end

    def apply(job)
      message_service.create!(
        seeker_id: seeker.id,
        schema: Events::SeekerApplied::V1,
        data: Events::SeekerApplied::Data::V1.new(
          seeker_first_name: seeker.first_name,
          seeker_last_name: seeker.last_name,
          seeker_email: seeker.email,
          seeker_phone_number: seeker.phone_number,
          seeker_id: seeker.id,
          job_id: job.id,
          employer_name: job.employer.name,
          employment_title: job.employment_title
        ),
        metadata: Messages::Nothing,
        version: 1
      )
    end

    private

    attr_reader :seeker
  end
end

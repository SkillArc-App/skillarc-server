class ApplicantService
  include MessageEmitter

  def initialize(applicant)
    @applicant = applicant
  end

  def update_status(status:, user_id:, reasons: [])
    applicant_status = ApplicantStatus.create!(
      id: SecureRandom.uuid,
      applicant:,
      status:
    )

    message_service.create!(
      schema: Events::ApplicantStatusUpdated::V6,
      application_id: applicant.id,
      data: {
        applicant_first_name: applicant.seeker.user.first_name,
        applicant_last_name: applicant.seeker.user.last_name,
        applicant_email: applicant.seeker.user.email,
        applicant_phone_number: applicant.seeker.user.phone_number,
        seeker_id: applicant.seeker.id,
        user_id: applicant.seeker.user.id,
        job_id: applicant.job.id,
        employer_name: applicant.job.employer.name,
        employment_title: applicant.job.employment_title,
        status: applicant.status.status,
        reasons: reasons.map do |reason|
          Events::ApplicantStatusUpdated::Reason::V2.new(
            id: reason[:id],
            response: reason[:response],
            reason_description: Reason.find(reason[:id]).description
          )
        end
      },
      metadata: {
        user_id:
      },
      occurred_at: applicant_status.created_at
    )
  end

  private

  attr_reader :applicant
end

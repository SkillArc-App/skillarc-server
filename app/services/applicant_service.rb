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

    applicant_status_reasons = reasons.map do |reason|
      ApplicantStatusReason.create!(
        applicant_status:,
        reason_id: reason[:id],
        response: reason[:response]
      )
    end

    message_service.create!(
      schema: Events::ApplicantStatusUpdated::V5,
      job_id: applicant.job.id,
      data: {
        applicant_id: applicant.id,
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
        reasons: applicant_status_reasons.map do |asr|
          Events::ApplicantStatusUpdated::Reason::V2.new(
            id: asr.reason_id,
            response: asr.response,
            reason_description: asr.reason.description
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

class ApplicantService
  def initialize(applicant)
    @applicant = applicant
  end

  def update_status(status:, reasons: [])
    applicant_status = ApplicantStatus.create!(
      id: SecureRandom.uuid,
      applicant:,
      status:
    )

    reasons.each do |reason|
      ApplicantStatusReason.create!(
        applicant_status:,
        reason_id: reason[:id],
        response: reason[:response]
      )
    end

    EventService.create!(
      event_schema: Events::ApplicantStatusUpdated::V3,
      aggregate_id: applicant.job.id,
      data: Events::ApplicantStatusUpdated::Data::V3.new(
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
        reasons: reasons.map do |reason|
          Events::ApplicantStatusUpdated::Reason::V1.new(
            id: reason[:id],
            response: reason[:response]
          )
        end
      ),
      occurred_at: applicant_status.created_at
    )
  end

  private

  attr_reader :applicant
end

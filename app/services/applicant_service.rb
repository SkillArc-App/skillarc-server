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

    reasons.each do |reason_id|
      ApplicantStatusReason.create!(
        applicant_status:,
        reason_id:
      )
    end

    EventService.create!(
      event_schema: Events::ApplicantStatusUpdated::V2,
      aggregate_id: applicant.job.id,
      data: Events::ApplicantStatusUpdated::Data::V2.new(
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
        status: applicant.status.status
      ),
      occurred_at: applicant_status.created_at
    )
  end

  private

  attr_reader :applicant
end

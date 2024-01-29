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
      event_schema: Events::ApplicantStatusUpdated::V1,
      aggregate_id: applicant.job.id,
      data: Events::Common::UntypedHashWrapper.build(
        applicant_id: applicant.id,
        profile_id: applicant.profile.id,
        user_id: applicant.profile.user.id,
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

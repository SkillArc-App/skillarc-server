class ApplicantService
  def initialize(applicant)
    @applicant = applicant
  end

  def update_status(status)
    applicant_status = ApplicantStatus.create!(
      id: SecureRandom.uuid,
      applicant: applicant,
      status: status
    )

    Resque.enqueue(
      CreateEventJob, 
      :event_type => Event::EventTypes::APPLICANT_STATUS_UPDATED,
      :aggregate_id => applicant.job.id,
      data: {
        applicant_id: applicant.id,
        profile_id: applicant.profile.id,
        user_id: applicant.profile.user.id,
        employment_title: applicant.job.employment_title,
        status: applicant.status.status
      },
      metadata: {},
      occurred_at: applicant_status.created_at
    )
  end

  private

  attr_reader :applicant
end
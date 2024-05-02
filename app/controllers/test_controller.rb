class TestController < ApplicationController # rubocop:disable Metrics/ClassLength
  include MessageEmitter

  def create_test_user
    user = create_user_with_messages

    render json: user
  end

  def create_coach
    user = create_user_with_messages

    role = Role.find_by(name: Role::Types::COACH)
    role ||= Role.create!(id: SecureRandom.uuid, name: Role::Types::COACH)

    UserRole.create!(
      id: SecureRandom.uuid,
      role:,
      user:
    )

    with_message_service do
      message_service.create!(
        user_id: user.id,
        schema: Events::RoleAdded::V1,
        data: {
          role: Role::Types::COACH,
          email: user.email,
          coach_id: SecureRandom.uuid
        }
      )
    end

    render json: user
  end

  def create_seeker
    seeker = create_seeker_with_messages

    render json: {
      user: seeker.user,
      seeker:
    }
  end

  def create_test_recruiter_with_applicant
    job = create_job_with_messages

    recruiter_user = create_user_with_messages
    FactoryBot.create(:recruiter, employer: job.employer, user: recruiter_user)

    with_message_service do
      message_service.create!(
        schema: Events::EmployerInviteAccepted::V1,
        employer_id: job.employer.id,
        data: {
          employer_invite_id: SecureRandom.uuid,
          invite_email: recruiter_user.email,
          employer_id: job.employer.id,
          employer_name: job.employer.name
        }
      )
    end

    seeker = create_seeker_with_messages
    applicant = create_application_with_message(job:, seeker:)

    render json: {
      recruiter: recruiter_user,
      job:,
      applicant: applicant.seeker.user,
      applicant_status: applicant.status
    }
  end

  def create_test_trainer_with_student
    program = FactoryBot.create(:program)

    training_provider = program.training_provider

    trainer_user = create_user_with_messages
    student_seeker = create_seeker_with_messages

    FactoryBot.create(:training_provider_profile, training_provider:, user: trainer_user)
    FactoryBot.create(:seeker_training_provider, training_provider:, program:, seeker: student_seeker)

    render json: {
      trainer: trainer_user,
      student: student_seeker.user,
      training_provider:,
      program:
    }
  end

  def create_job
    render json: create_job_with_messages
  end

  def create_seeker_lead
    lead = FactoryBot.create(:coaches__coach_seeker_context, :lead, phone_number: Faker::PhoneNumber.phone_number)
    Analytics::DimPerson.create!(
      first_name: lead.first_name,
      last_name: lead.last_name,
      email: lead.email,
      phone_number: lead.phone_number,
      lead_id: lead.lead_id,
      kind: Analytics::DimPerson::Kind::LEAD
    )

    render json: lead
  end

  def create_active_seeker
    seeker = create_seeker_with_messages

    job = create_job_with_messages
    create_application_with_message(job:, seeker:)

    render json: seeker.user
  end

  def assert_no_failed_jobs
    if Resque::Failure.count.zero?
      head :no_content
    else
      failures = Resque::Failure.all

      failure = if failures.is_a?(Hash)
                  failures
                else
                  failures[0]
                end

      render json: { exception: failure["exception"], message: failure["error"], backtrace: failure["backtrace"] }, status: :ok
    end
  end

  def jobs_settled
    if Resque.peek(:default).nil?
      render json: { settled: true }, status: :ok
    else
      render json: { settled: false }, status: :ok
    end
  end

  def clear_failed_jobs
    Resque::Failure.clear
  end

  private

  def create_user_with_messages
    user = FactoryBot.create(:user, onboarding_session: nil)

    with_message_service do
      message_service.create!(
        user_id: user.id,
        schema: Events::UserCreated::V1,
        data: {
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          sub: user.sub
        }
      )
    end

    user
  end

  def create_seeker_with_messages
    user = create_user_with_messages
    seeker = FactoryBot.create(:seeker, user:)

    with_message_service do
      message_service.create!(
        user_id: user.id,
        schema: Events::SeekerCreated::V1,
        data: {
          id: seeker.id,
          user_id: user.id
        }
      )
      message_service.create!(
        seeker_id: seeker.id,
        schema: Events::OnboardingStarted::V1,
        data: {
          user_id: user.id
        }
      )
      message_service.create!(
        seeker_id: seeker.id,
        schema: Events::OnboardingCompleted::V2,
        data: Messages::Nothing
      )
    end

    seeker
  end

  def create_application_with_message(job:, seeker:)
    applicant = FactoryBot.create(:applicant, job:, seeker:)

    with_message_service do
      message_service.create!(
        schema: Events::ApplicantStatusUpdated::V6,
        application_id: applicant.id,
        data: {
          applicant_first_name: seeker.user.first_name,
          applicant_last_name: seeker.user.last_name,
          applicant_email: seeker.user.email,
          applicant_phone_number: seeker.user.phone_number,
          seeker_id: seeker.id,
          user_id: seeker.user.id,
          job_id: job.id,
          employer_name: job.employer.name,
          employment_title: job.employment_title,
          status: ApplicantStatus::StatusTypes::NEW,
          reasons: []
        },
        metadata: {
          user_id: seeker.user_id
        }
      )
    end

    applicant
  end

  def create_job_with_messages
    employer_id = SecureRandom.uuid
    job_id = SecureRandom.uuid

    employer = FactoryBot.create(:employer, id: employer_id, name: SecureRandom.uuid, bio: "We are a company.")
    job = FactoryBot.create(:job, employer:, id: job_id,
                                  employment_title: SecureRandom.uuid,
                                  benefits_description: "We have benefits.",
                                  location: "Columbus Ohio")

    with_message_service do
      message_service.create!(
        schema: Events::EmployerCreated::V1,
        employer_id:,
        data: {
          name: employer.name,
          location: "Columbus Ohio",
          bio: "We are a company.",
          logo_url: "www.google.com"
        }
      )

      message_service.create!(
        schema: Events::JobCreated::V3,
        job_id:,
        data: {
          category: Job::Categories::MARKETPLACE,
          employment_title: job.employment_title,
          employer_name: "Acme Inc.",
          employer_id:,
          benefits_description: "We have benefits.",
          location: "Columbus Ohio",
          employment_type: Job::EmploymentTypes::FULLTIME,
          hide_job: false
        }
      )
    end

    job
  end
end

class TestController < ApplicationController # rubocop:disable Metrics/ClassLength
  def create_test_user
    user = FactoryBot.create(:user)

    Coaches::CoachSeekerContext.create!(
      user_id: user.id,
      seeker_id: nil,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: Time.zone.now,
      last_active_on: Time.zone.now
    )

    render json: user
  end

  def create_coach
    user = FactoryBot.create(:user)

    role = Role.find_by(name: Role::Types::COACH)
    role ||= Role.create!(id: SecureRandom.uuid, name: Role::Types::COACH)

    UserRole.create!(
      id: SecureRandom.uuid,
      role:,
      user:
    )

    coach = Coaches::Coach.create!(
      id: SecureRandom.uuid,
      coach_id: SecureRandom.uuid,
      user_id: user.id,
      email: user.email
    )

    Coaches::CoachSeekerContext.create!(
      user_id: user.id,
      seeker_id: nil,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: Time.zone.now,
      last_active_on: Time.zone.now
    )

    render json: coach
  end

  def create_seeker
    user = FactoryBot.create(:user, onboarding_sessions: [FactoryBot.build(:onboarding_session, completed_at: Time.zone.now)])
    seeker = FactoryBot.create(:seeker, user:)

    Coaches::CoachSeekerContext.create!(
      user_id: user.id,
      seeker_id: seeker.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: Time.zone.now,
      last_active_on: Time.zone.now
    )

    render json: {
      user:,
      seeker:
    }
  end

  def create_test_recruiter_with_applicant
    recruiter = FactoryBot.create(:recruiter)
    employer = recruiter.employer

    employers_employer = FactoryBot.create(:employers_employer, employer_id: employer.id, name: employer.name)
    FactoryBot.create(:employers_recruiter, employer: employers_employer, email: recruiter.user.email)

    job = FactoryBot.create(:job, employer: recruiter.employer)
    employers_job = FactoryBot.create(:employers_job, job_id: job.id, employer: employers_employer, employment_title: job.employment_title)

    applicant = FactoryBot.create(:applicant, job:)
    FactoryBot.create(
      :employers_applicant,
      applicant_id: applicant.id,
      job: employers_job,
      seeker_id: applicant.seeker.id,
      first_name: applicant.seeker.user.first_name,
      last_name: applicant.seeker.user.last_name,
      email: applicant.seeker.user.email,
      phone_number: applicant.seeker.user.phone_number,
      status: applicant.status.status,
      status_as_of: Time.zone.now
    )

    Coaches::CoachSeekerContext.create!(
      user_id: recruiter.user.id,
      seeker_id: nil,
      first_name: recruiter.user.first_name,
      last_name: recruiter.user.last_name,
      email: recruiter.user.email,
      phone_number: recruiter.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: Time.zone.now,
      last_active_on: Time.zone.now
    )

    Coaches::CoachSeekerContext.create!(
      user_id: applicant.seeker.user.id,
      seeker_id: nil,
      first_name: applicant.seeker.user.first_name,
      last_name: applicant.seeker.user.last_name,
      email: applicant.seeker.user.email,
      phone_number: applicant.seeker.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: Time.zone.now,
      last_active_on: Time.zone.now
    )

    render json: {
      recruiter: recruiter.user,
      job:,
      applicant: applicant.seeker.user,
      applicant_status: applicant.status
    }
  end

  def create_test_trainer_with_student
    program = FactoryBot.create(:program)

    training_provider = program.training_provider
    trainer = FactoryBot.create(:training_provider_profile, training_provider:)
    student = FactoryBot.create(:seeker_training_provider, training_provider:, program:)

    Coaches::CoachSeekerContext.create!(
      user_id: trainer.user.id,
      seeker_id: nil,
      first_name: trainer.user.first_name,
      last_name: trainer.user.last_name,
      email: trainer.user.email,
      phone_number: trainer.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: Time.zone.now,
      last_active_on: Time.zone.now
    )

    Coaches::CoachSeekerContext.create!(
      user_id: student.user.id,
      seeker_id: nil,
      first_name: student.user.first_name,
      last_name: student.user.last_name,
      email: student.user.email,
      phone_number: student.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: Time.zone.now,
      last_active_on: Time.zone.now
    )

    FactoryBot.create(:seeker, user: student.user)

    render json: {
      trainer: trainer.user,
      student: student.user,
      training_provider:,
      program:
    }
  end

  def create_job
    employer = FactoryBot.create(:employer)
    employers_employer = FactoryBot.create(:employers_employer, employer_id: employer.id, name: employer.name)

    job = FactoryBot.create(:job, employment_title: SecureRandom.uuid, employer:)
    FactoryBot.create(:employers_job, job_id: job.id, employer: employers_employer, employment_title: job.employment_title)

    render json: job
  end

  def create_seeker_lead
    render json: FactoryBot.create(:coaches__seeker_lead)
  end

  def create_active_seeker
    user = FactoryBot.create(:user)
    seeker = FactoryBot.create(:seeker, user:)

    csc = Coaches::CoachSeekerContext.create!(
      user_id: user.id,
      seeker_id: seeker.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: Time.zone.now,
      last_active_on: Time.zone.now
    )

    employer = FactoryBot.create(:employer)
    employers_employer = FactoryBot.create(:employers_employer, employer_id: employer.id)

    job = FactoryBot.create(:job, employer:)
    FactoryBot.create(:employers_job, job_id: job.id, employer: employers_employer, employment_title: job.employment_title)

    FactoryBot.create(:desired_skill, job:)

    csc.seeker_applications.create!(
      application_id: SecureRandom.uuid,
      job_id: job.id,
      employer_name: job.employer.name,
      employment_title: job.employment_title,
      status: ApplicantStatus::StatusTypes::PASS
    )

    render json: seeker.user
  end

  def assert_no_failed_jobs
    failure_count = Resque::Failure.count
    Resque::Failure.clear

    if failure_count.zero?
      head :no_content
    else
      render json: { message: 'Failed resque jobs' }, status: :internal_server_error
    end
  end

  def reset_test_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    system "rails db:seed"

    head :ok
  end
end

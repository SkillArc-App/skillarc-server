class TestController < ApplicationController # rubocop:disable Metrics/ClassLength
  def create_test_user
    user = FactoryBot.create(:user)

    now = Time.zone.now
    Coaches::CoachSeekerContext.create!(
      user_id: user.id,
      context_id: user.id,
      seeker_id: nil,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      kind: Coaches::CoachSeekerContext::Kind::SEEKER,
      skill_level: "beginner",
      stage: "Profile Created",
      seeker_captured_at: now,
      last_contacted_at: now,
      last_active_on: now
    )

    Analytics::DimPerson.create!(
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      user_id: user.id,
      user_created_at: user.created_at,
      kind: Analytics::DimPerson::Kind::USER
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

    now = Time.zone.now
    Coaches::CoachSeekerContext.create!(
      user_id: user.id,
      context_id: user.id,
      seeker_id: nil,
      first_name: user.first_name,
      last_name: user.last_name,
      kind: Coaches::CoachSeekerContext::Kind::SEEKER,
      email: user.email,
      phone_number: user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      seeker_captured_at: now,
      last_contacted_at: now,
      last_active_on: now
    )

    Analytics::DimPerson.create!(
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      user_id: user.id,
      user_created_at: user.created_at,
      kind: Analytics::DimPerson::Kind::COACH
    )

    render json: coach
  end

  def create_seeker
    user = FactoryBot.create(:user, onboarding_sessions: [FactoryBot.build(:onboarding_session, completed_at: Time.zone.now)])
    seeker = FactoryBot.create(:seeker, user:)

    now = Time.zone.now
    Coaches::CoachSeekerContext.create!(
      user_id: user.id,
      context_id: user.id,
      seeker_id: seeker.id,
      first_name: user.first_name,
      kind: Coaches::CoachSeekerContext::Kind::SEEKER,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      seeker_captured_at: now,
      last_contacted_at: now,
      last_active_on: now
    )

    Analytics::DimPerson.create!(
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      user_id: user.id,
      user_created_at: user.created_at,
      kind: Analytics::DimPerson::Kind::SEEKER
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
    dim_job = Analytics::DimJob.create!(
      category: job.category,
      employment_title: job.employment_title,
      employment_type: job.employment_type,
      job_id: job.id,
      job_created_at: job.created_at
    )

    employers_job = FactoryBot.create(:employers_job, job_id: job.id, employer: employers_employer, employment_title: job.employment_title)
    search_job = FactoryBot.create(:search__job, job_id: job.id, employment_title: job.employment_title, employer_id: employer.id, employer_name: employer.name)

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
    FactoryBot.create(
      :search__application,
      search_job:,
      status: applicant.status.status,
      application_id: applicant.id,
      seeker_id: applicant.seeker.id,
      job_id: job.id
    )
    dim_person = Analytics::DimPerson.create!(
      first_name: applicant.seeker.user.first_name,
      last_name: applicant.seeker.user.last_name,
      email: applicant.seeker.user.email,
      phone_number: applicant.seeker.user.phone_number,
      user_id: applicant.seeker.user.id,
      user_created_at: applicant.seeker.user.created_at,
      kind: Analytics::DimPerson::Kind::SEEKER
    )
    Analytics::FactApplication.create!(
      application_id: applicant.id,
      application_number: 1,
      application_opened_at: applicant.created_at,
      status: applicant.status.status,
      dim_job:,
      dim_person:
    )

    now = Time.zone.now
    Coaches::CoachSeekerContext.create!(
      user_id: recruiter.user.id,
      context_id: recruiter.user.id,
      seeker_id: nil,
      first_name: recruiter.user.first_name,
      kind: Coaches::CoachSeekerContext::Kind::SEEKER,
      last_name: recruiter.user.last_name,
      email: recruiter.user.email,
      phone_number: recruiter.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      seeker_captured_at: now,
      last_contacted_at: now,
      last_active_on: now
    )

    Analytics::DimPerson.create!(
      first_name: recruiter.user.first_name,
      last_name: recruiter.user.last_name,
      email: recruiter.user.email,
      phone_number: recruiter.user.phone_number,
      user_id: recruiter.user.id,
      user_created_at: recruiter.user.created_at,
      kind: Analytics::DimPerson::Kind::RECRUITER
    )

    Coaches::CoachSeekerContext.create!(
      user_id: applicant.seeker.user.id,
      context_id: applicant.seeker.user.id,
      seeker_id: nil,
      first_name: applicant.seeker.user.first_name,
      kind: Coaches::CoachSeekerContext::Kind::SEEKER,
      last_name: applicant.seeker.user.last_name,
      email: applicant.seeker.user.email,
      phone_number: applicant.seeker.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      seeker_captured_at: now,
      last_contacted_at: now,
      last_active_on: now
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

    now = Time.zone.now
    Coaches::CoachSeekerContext.create!(
      user_id: trainer.user.id,
      context_id: trainer.user.id,
      seeker_id: nil,
      first_name: trainer.user.first_name,
      kind: Coaches::CoachSeekerContext::Kind::SEEKER,
      last_name: trainer.user.last_name,
      email: trainer.user.email,
      phone_number: trainer.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      seeker_captured_at: now,
      last_contacted_at: now,
      last_active_on: now
    )

    Analytics::DimPerson.create!(
      first_name: trainer.user.first_name,
      last_name: trainer.user.last_name,
      email: trainer.user.email,
      phone_number: trainer.user.phone_number,
      user_id: trainer.user.id,
      user_created_at: trainer.user.created_at,
      kind: Analytics::DimPerson::Kind::TRAINING_PROVIDER
    )

    Coaches::CoachSeekerContext.create!(
      user_id: student.user.id,
      context_id: student.user.id,
      seeker_id: nil,
      first_name: student.user.first_name,
      kind: Coaches::CoachSeekerContext::Kind::SEEKER,
      last_name: student.user.last_name,
      email: student.user.email,
      phone_number: student.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      seeker_captured_at: now,
      last_contacted_at: now,
      last_active_on: now
    )

    Analytics::DimPerson.create!(
      first_name: student.user.first_name,
      last_name: student.user.last_name,
      email: student.user.email,
      phone_number: student.user.phone_number,
      user_id: student.user.id,
      user_created_at: student.user.created_at,
      kind: Analytics::DimPerson::Kind::SEEKER
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

    FactoryBot.create(:search__job, job_id: job.id, employment_title: job.employment_title, employer_id: employer.id, employer_name: employer.name)

    Analytics::DimJob.create!(
      category: job.category,
      employment_title: job.employment_title,
      employment_type: job.employment_type,
      job_id: job.id,
      job_created_at: job.created_at
    )

    render json: job
  end

  def create_seeker_lead
    render json: FactoryBot.create(:coaches__coach_seeker_context, :lead, phone_number: Faker::PhoneNumber.phone_number)
  end

  def create_active_seeker
    user = FactoryBot.create(:user)
    seeker = FactoryBot.create(:seeker, user:)

    now = Time.zone.now
    csc = Coaches::CoachSeekerContext.create!(
      user_id: user.id,
      context_id: user.id,
      seeker_id: seeker.id,
      seeker_captured_at: now,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      kind: Coaches::CoachSeekerContext::Kind::SEEKER,
      skill_level: "beginner",
      stage: "Profile Created",
      last_contacted_at: now,
      last_active_on: now
    )

    employer = FactoryBot.create(:employer)
    employers_employer = FactoryBot.create(:employers_employer, employer_id: employer.id)

    job = FactoryBot.create(:job, employer:)
    FactoryBot.create(:employers_job, job_id: job.id, employer: employers_employer, employment_title: job.employment_title)
    FactoryBot.create(:search__job, job_id: job.id, employment_title: job.employment_title, employer_id: employer.id, employer_name: employer.name)

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
    if Resque::Failure.count.zero?
      head :no_content
    else
      failures = Resque::Failure.all

      failure = if failures.is_a?(Hash)
                  failures
                else
                  failures[0]
                end

      Resque::Failure.clear

      render json: { exception: failure["exception"], message: failure["error"], backtrace: failure["backtrace"] }, status: :ok
    end
  end

  def reset_test_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    system "rails db:seed"

    head :ok
  end
end

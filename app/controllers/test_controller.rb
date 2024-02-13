class TestController < ApplicationController
  def create_test_user
    user = FactoryBot.create(:user)

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
    job = FactoryBot.create(:job, employer: recruiter.employer)
    applicant = FactoryBot.create(:applicant, job:)

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
    FactoryBot.create(:seeker, user: student.user)

    render json: {
      trainer: trainer.user,
      student: student.user,
      training_provider:,
      program:
    }
  end

  def create_job
    render json: FactoryBot.create(:job, employment_title: SecureRandom.uuid)
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

    job = FactoryBot.create(:job)
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

  def reset_test_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    system "rails db:seed"

    head :ok
  end
end

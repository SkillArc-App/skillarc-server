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
    profile = FactoryBot.create(:profile)

    Coaches::CoachSeekerContext.create!(
      user_id: profile.user.id,
      profile_id: profile.id,
      first_name: profile.user.first_name,
      last_name: profile.user.last_name,
      email: profile.user.email,
      phone_number: profile.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      barriers: [],
      last_contacted_at: Time.now,
      last_active_on: Time.now
    )

    render json: profile.user
  end

  def create_test_recruiter_with_applicant
    recruiter = FactoryBot.create(:recruiter)
    job = FactoryBot.create(:job, employer: recruiter.employer)
    applicant = FactoryBot.create(:applicant, job:)

    render json: {
      recruiter: recruiter.user,
      job:,
      applicant: applicant.profile.user,
      applicant_status: applicant.status
    }
  end

  def create_active_seeker
    profile = FactoryBot.create(:profile)

    csc = Coaches::CoachSeekerContext.create!(
      user_id: profile.user.id,
      profile_id: profile.id,
      first_name: profile.user.first_name,
      last_name: profile.user.last_name,
      email: profile.user.email,
      phone_number: profile.user.phone_number,
      skill_level: "beginner",
      stage: "Profile Created",
      barriers: [],
      last_contacted_at: Time.now,
      last_active_on: Time.now
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

    render json: profile.user
  end

  def reset_test_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    system "rails db:seed"

    head :ok
  end
end

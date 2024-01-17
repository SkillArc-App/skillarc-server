class TestController < ApplicationController
  def create_test_user
    user = User.create!(
      id: SecureRandom.uuid,
      email: Faker::Internet.email,
      sub: Faker::Internet.uuid
    )

    render json: user
  end

  def create_coach
    email = Faker::Internet.email

    user_id = User.create!(
      id: SecureRandom.uuid,
      sub: Faker::Internet.uuid,
      email:
    ).id

    role = Role.find_by(name: Role::Types::COACH)

    UserRole.create!(
      id: SecureRandom.uuid,
      role:,
      user_id:
    )

    coach = Coaches::Coach.create!(
      id: SecureRandom.uuid,
      user_id:,
      email:
    )

    render json: coach
  end

  def create_seeker
    profile = Profile.create!(
      id: SecureRandom.uuid,
      bio: 'I learn stuff',
      status: "I'm an adult with some work experience. Looking to switch to trades.",
      user: User.new(
        id: SecureRandom.uuid,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        sub: SecureRandom.uuid
      )
    )

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
    user = FactoryBot.create(:user, email: Faker::Internet.email, sub: Faker::Internet.uuid)

    profile = FactoryBot.create(:profile, user:)

    employer = FactoryBot.create(:employer)

    FactoryBot.create(:recruiter, user:, employer:)

    job = FactoryBot.create(:job, employer:)

    applicant = FactoryBot.create(:applicant, job:, profile:)

    FactoryBot.create(:applicant_status, :new, applicant:)

    render json: user
  end

  def reset_test_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    system "rails db:seed"

    head :ok
  end
end

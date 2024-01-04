class TestController < ApplicationController
  def create_test_user
    user = User.create(
      id: SecureRandom.uuid,
      email: Faker::Internet.email,
      sub: Faker::Internet.uuid
    )

    render json: user
  end

  def create_test_recruiter_with_applicant
    user = FactoryBot.create(:user, email: Faker::Internet.email, sub: Faker::Internet.uuid)

    profile = FactoryBot.create(:profile, user:)

    employer = FactoryBot.create(:employer)

    recruiter = FactoryBot.create(:recruiter, user:, employer:)

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

class TestController < ApplicationController
  def create_test_user
    user = User.create(
      id: SecureRandom.uuid,
      email: Faker::Internet.email,
      sub: Faker::Internet.uuid,
    )

    render json: user
  end

  def reset_test_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    system "rails db:seed"

    head :ok
  end
end

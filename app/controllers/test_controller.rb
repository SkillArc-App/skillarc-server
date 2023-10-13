class TestController < ApplicationController
  skip_before_action :verify_authenticity_token

  def reset_test_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    system "rails db:seed"

    head :ok
  end
end

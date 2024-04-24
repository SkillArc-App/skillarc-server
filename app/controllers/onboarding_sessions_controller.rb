class OnboardingSessionsController < ApplicationController
  include Secured
  include MessageEmitter

  before_action :authorize

  def index
    os = OnboardingSession.where(user_id: current_user.id).first

    render json: os.as_json
  end

  def create
    with_message_service do
      onboarding_session = OnboardingSession.find_or_create_by!(user_id: current_user.id) do |os|
        os.id = SecureRandom.uuid
        os.started_at = Time.zone.now
      end

      render json: onboarding_session.as_json
    end
  end

  def update
    # find onboarding session by id
    os = OnboardingSession.find(params[:id])

    filtered = params.require("onboarding_session").permit(
      responses: {
        education: {
          response: %i[
            org
            title
            grad_year
            gpa
            activities
          ]
        },
        experience: {
          response: %i[
            company
            position
            start_date
            current
            end_date
            description
          ]
        },
        name: {
          response: %i[
            first_name
            last_name
            phone_number
            date_of_birth
          ]
        },
        opportunity_interests: {
          response: []
        },
        other: {
          response: %i[
            activity
            start_date
            end_date
            learning
          ]
        },
        reliability: {
          response: []
        },
        training_provider: {
          response: []
        }
      }
    ).to_h.symbolize_keys

    responses = filtered[:responses]

    with_message_service do
      Onboarding.new(onboarding_session: os).update(responses:)
    end

    render json: os.as_json
  end
end

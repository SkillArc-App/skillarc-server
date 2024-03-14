class OnboardingSessionsController < ApplicationController
  include Secured
  include Cereal
  include EventEmitter

  before_action :authorize

  def index
    os = OnboardingSession.where(user_id: current_user.id).first

    render json: deep_transform_keys(os.as_json) { |key| to_camel_case(key) }
  end

  def create
    with_event_service do
      onboarding_session = OnboardingSession.find_or_create_by!(user_id: current_user.id) do |os|
        os.id = SecureRandom.uuid
        os.started_at = Time.zone.now
      end

      render json: deep_transform_keys(onboarding_session.as_json) { |key| to_camel_case(key) }
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
            gradYear
            gpa
            activities
          ]
        },
        experience: {
          response: %i[
            company
            position
            startDate
            current
            endDate
            description
          ]
        },
        name: {
          response: %i[
            firstName
            lastName
            phoneNumber
            dateOfBirth
          ]
        },
        opportunityInterests: {
          response: []
        },
        other: {
          response: %i[
            activity
            startDate
            endDate
            learning
          ]
        },
        reliability: {
          response: []
        },
        trainingProvider: {
          response: []
        }
      }
    ).to_h.symbolize_keys

    responses = filtered[:responses]

    with_event_service do
      Onboarding.new(onboarding_session: os).update(responses:)
    end

    render json: deep_transform_keys(os.as_json) { |key| to_camel_case(key) }
  end
end

class OnboardingSessionsController < ApplicationController
  include Secured
  include MessageEmitter

  before_action :authorize

  def create
    with_message_service do
      if current_user.seeker.blank?
        seeker = Seeker.create!(user: current_user)

        message_service.create!(
          schema: Events::SeekerCreated::V1,
          trace_id: request.request_id,
          seeker_id: seeker.id,
          data: {
            user_id: current_user.id
          }
        )
      end

      message_service.create!(
        schema: Commands::StartOnboarding::V1,
        trace_id: request.request_id,
        seeker_id: current_user.seeker.id,
        data: {
          user_id: current_user.id
        }
      )
    end

    render json: serialize_onboarding_session(current_user.seeker.id)
  end

  def update
    seeker_id = current_user.seeker&.id

    if seeker_id.blank?
      render json: { error: 'Seeker not found' }, status: :bad_request
      return
    end

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
      Onboarding.new(
        message_service:,
        seeker_id:,
        user_id: current_user.id,
        trace_id: request.request_id
      ).update(responses:)
    end

    render json: serialize_onboarding_session(seeker_id)
  end

  private

  def serialize_onboarding_session(seeker_id)
    messages = MessageService.aggregate_events(Aggregates::Seeker.new(seeker_id:))
    status = Seekers::Projectors::OnboardingStatus.new.project(messages)

    {
      seeker_id:,
      next_step: status.next_step,
      progress: status.progress
    }
  end
end

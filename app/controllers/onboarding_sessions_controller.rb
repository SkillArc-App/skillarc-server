class OnboardingSessionsController < ApplicationController
  include Secured
  include MessageEmitter

  before_action :authorize

  def show
    render json: serialize_onboarding_session(current_user.seeker&.id)
  end

  def create
    filtered = params.permit(:first_name, :last_name, :phone_number, :date_of_birth).to_h.symbolize_keys

    with_message_service do
      person_id = find_or_create_person_id(request.request_id)

      message_service.create!(
        schema: Commands::StartOnboarding::V1,
        trace_id: request.request_id,
        seeker_id: person_id,
        data: {
          user_id: current_user.id
        }
      )

      message_service.create!(
        seeker_id: person_id,
        trace_id: request.request_id,
        schema: Events::BasicInfoAdded::V1,
        data: {
          user_id: current_user.id,
          first_name: filtered[:first_name],
          last_name: filtered[:last_name],
          phone_number: filtered[:phone_number],
          date_of_birth: filtered[:date_of_birth]
        }
      )
    end

    head :created
  end

  def update
    person_id = find_person_id

    if person_id.blank?
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
        seeker_id: person_id,
        user_id: current_user.id,
        trace_id: request.request_id
      ).update(responses:)
    end

    render json: serialize_onboarding_session(person_id)
  end

  private

  def find_or_create_person_id(trace_id)
    person_id = find_person_id

    return person_id if person_id.present?

    person_id = SecureRandom.uuid

    message_service.create!(
      schema: Events::SeekerCreated::V1,
      trace_id:,
      seeker_id: person_id,
      data: {
        user_id: current_user.id
      }
    )

    person_id
  end

  def find_person_id
    return current_user.person_id if current_user.person_id.present?

    # Temp slow code path while we cut over
    Events::SeekerCreated::V1.all_messages.detect do |m|
      m.data.user_id == current_user.id
    end&.aggregate&.id
  end

  def serialize_onboarding_session(person_id)
    messages = if person_id.nil?
                 []
               else
                 MessageService.aggregate_events(Aggregates::Seeker.new(seeker_id: person_id))
               end
    status = Seekers::Projectors::OnboardingStatus.new.project(messages)

    {
      seeker_id: person_id,
      next_step: status.next_step,
      progress: status.progress
    }
  end
end

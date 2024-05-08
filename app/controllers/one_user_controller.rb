class OneUserController < ApplicationController
  include Secured

  before_action :authorize

  def index
    seeker = current_user.seeker

    notifications = Contact::Notification.where(user_id: current_user.id).order(created_at: :desc).limit(10).map do |n|
      {
        notificationTitle: n.title,
        notificationBody: n.body,
        read: n.read?,
        url: n.url
      }
    end

    roles = current_user.roles.map do |r|
      {
        role: {
          name: r.name
        }
      }
    end || []

    completed_at = nil

    if seeker&.id.present?
      completed_at = Projections::Aggregates::GetFirst.project(
        aggregate: Aggregates::Seeker.new(seeker_id: seeker&.id),
        schema: Events::OnboardingCompleted::V2
      )&.occurred_at
    end

    render json: {
      id: current_user.id,
      first_name: current_user.first_name,
      last_name: current_user.last_name,
      email: current_user.email,
      onboarding_session: {
        completed_at:
      },
      user_roles: roles,
      notifications:,
      profile: {
        id: seeker&.id,
        about: seeker&.about,
        userId: seeker&.user_id,
        missingProfileItems: ProfileCompleteness.new(seeker).status.missing
      },
      recruiter: current_user.recruiter && {
        id: current_user.recruiter&.id
      },
      training_provider_profile: current_user.training_provider_profile && {
        id: current_user.training_provider_profile&.id
      }
    }
  end
end

class StoriesController < ApplicationController
  include Secured

  before_action :authorize

  def create
    story = Story.create!(
      **params.require(:story).permit(:prompt, :response),
      id: SecureRandom.uuid,
      profile: current_user.profile,
      seeker: current_user.seeker
    )

    render json: story
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def update
    story = Story.find(params[:id])

    story.update!(**params.require(:story).permit(:prompt, :response))

    render json: story
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def destroy
    story = Story.find(params[:id])

    story.destroy!

    render json: story
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end
end

class StoriesController < ApplicationController
  include Secured

  before_action :authorize

  def update
    begin
      story = Story.find(params[:id])

      story.update!(**params.require(:story).permit(:prompt, :response))

      render json: story
    rescue => e
      render json: { error: e.message }, status: 400
    end
  end

  def create
    begin
      story = Story.create!(
        **params.require(:story).permit(:prompt, :response),
        id: SecureRandom.uuid,
        profile_id: current_user.profile.id
      )

      render json: story
    rescue => e
      binding.pry
      render json: { error: e.message }, status: 400
    end
  end

  def destroy
    begin
      story = Story.find(params[:id])

      story.destroy!

      render json: story
    rescue => e
      render json: { error: e.message }, status: 400
    end
  end
end

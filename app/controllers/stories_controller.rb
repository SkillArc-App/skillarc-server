class StoriesController < ApplicationController
  include Secured
  include SeekerAuth
  include EventEmitter

  before_action :authorize
  before_action :set_seeker
  before_action :seeker_editor_authorize

  def create
    with_event_service do
      story = Seekers::StoriesService.new(seeker).create(
        **params.require(:story).permit(:prompt, :response).to_h.symbolize_keys
      )

      render json: story, status: :created
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def update
    story = Story.find(params[:id])

    with_event_service do
      story = Seekers::StoriesService.new(seeker).update(
        story:,
        **params.require(:story).permit(:prompt, :response).to_h.symbolize_keys
      )
    end

    render json: story
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def destroy
    story = Story.find(params[:id])

    with_event_service do
      Seekers::StoriesService.new(seeker).destroy(story:)
    end

    render json: story
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  attr_reader :seeker

  def set_seeker
    @seeker = Seeker.find(params[:profile_id])
  end
end

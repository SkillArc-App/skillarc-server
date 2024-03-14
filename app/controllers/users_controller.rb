class UsersController < ApplicationController
  include Secured
  include CoachAuth
  include EventEmitter

  before_action :authorize
  before_action :authorize_is_user_or_coach
  before_action :set_user, only: [:update]

  def update
    with_event_service do
      render json: Seekers::UserService.new(user.id).update(**user_params.to_h.symbolize_keys)
    end
  end

  private

  attr_reader :user

  def authorize_is_user_or_coach
    render json: {}, status: :unauthorized unless current_user.id == params[:id] || coach?
  end

  def user_params
    params.permit(:about, :first_name, :last_name, :phone_number, :zip_code)
  end

  def set_user
    @user = User.find(params[:id])
  end
end

class UserEventsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize
  before_action :set_user

  def show
    render json: UserEvents.new(user).all
  end

  private

  attr_reader :user

  def set_user
    @user = User.find(params[:id])
  end
end

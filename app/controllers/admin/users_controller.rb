module Admin
  class UsersController < ApplicationController
    include Secured
    include Admin

    before_action :authorize, unless: -> { Rails.env.development? }
    before_action :admin_authorize, unless: -> { Rails.env.development? }

    def index
      render json: User.all
    end
  end
end

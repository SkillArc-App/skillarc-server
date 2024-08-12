module Admin
  class UsersController < ApplicationController
    def index
      render json: User.all
    end
  end
end

module Admin
  class AdminController < ApplicationController
    include Secured
    include Admin

    before_action :authorize
    before_action :admin_authorize
  end
end

class SecureController < ApplicationController
  include Secured

  before_action :authorize
end

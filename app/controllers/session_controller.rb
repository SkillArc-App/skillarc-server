class SessionController < ApplicationController
  include Secured

  before_action :authorize

  def create
    EventService.create!(
      event_schema: Events::SessionStarted::V1,
      user_id: current_user.id,
      data: Messages::Nothing
    )

    head :accepted
  end
end

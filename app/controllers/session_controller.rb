class SessionController < ApplicationController
  include Secured

  before_action :authorize

  def create
    EventService.create!(
      event_schema: Events::SessionStarted::V1,
      aggregate_id: current_user.id,
      data: Events::Common::Nothing
    )

    head :accepted
  end
end

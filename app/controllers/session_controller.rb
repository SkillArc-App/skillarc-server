class SessionController < ApplicationController
  include EventEmitter
  include Secured

  before_action :authorize

  def create
    with_event_service do
      event_service.create!(
        event_schema: Events::SessionStarted::V1,
        user_id: current_user.id,
        data: Messages::Nothing
      )

      head :accepted
    end
  end
end

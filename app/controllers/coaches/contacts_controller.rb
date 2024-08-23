module Coaches
  class ContactsController < CoachesController
    def create
      with_message_service do
        data = params.permit(
          :context_id,
          :note,
          :contact_direction,
          :contact_type
        ).to_h.symbolize_keys

        message_service.create!(
          trace_id: request.request_id,
          schema: Users::Commands::Contact::V1,
          user_id: current_user.id,
          data: {
            person_id: data[:context_id],
            note: data[:note],
            contact_direction: data[:contact_direction],
            contact_type: data[:contact_type]
          }
        )
      end

      head :created
    end
  end
end

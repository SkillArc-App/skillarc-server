module Coaches
  class LeadsController < CoachesController
    before_action :set_coach

    def create
      lead = params.require(:lead).permit(
        :lead_id,
        :email,
        :phone_number,
        :first_name,
        :last_name
      ).to_h.symbolize_keys

      with_message_service do
        message_service.create!(
          person_id: SecureRandom.uuid,
          trace_id: request.request_id,
          schema: People::Commands::AddPerson::V2,
          data: {
            user_id: nil,
            date_of_birth: nil,
            email: lead[:email],
            phone_number: lead[:phone_number],
            first_name: lead[:first_name],
            last_name: lead[:last_name],
            source_kind: People::SourceKind::COACH,
            source_identifier: coach.id
          }
        )
      end

      head :created
    end
  end
end

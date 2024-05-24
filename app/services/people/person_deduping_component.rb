module People
  class PersonDedupingComponent < MessageReactor
    def can_replay?
      true
    end

    on_message Commands::AddPerson::V1 do |message|
      # If we already created the person return
      return if Projectors::Aggregates::HasOccurred.project(
        aggregate: message.aggregate,
        schema: Events::PersonAdded::V1
      )

      # if we have a matching email or phone
      return if matching_email?(message.data.email, message.data.user_id, message.trace_id)
      return if matching_phone_number?(message.data.phone_number, message.data.user_id, message.trace_id)

      # If not create the new person
      message_service.create_once_for_trace!(
        schema: Events::PersonAdded::V1,
        trace_id: message.trace_id,
        person_id: message.aggregate.id,
        data: {
          first_name: message.data.first_name,
          last_name: message.data.last_name,
          email: message.data.email,
          phone_number: message.data.phone_number
        }
      )

      # If the command contained a user associate them
      emit_associated_to_user(message.aggregate.id, message.data.user_id, message.trace_id) if message.data.user_id.present?
    end

    on_message Events::PersonAdded::V1 do |message|
      # If we have a phone associate it
      if message.data.phone_number.present?
        message_service.create_once_for_trace!(
          schema: Events::PersonAssociatedToPhoneNumber::V1,
          trace_id: message.trace_id,
          phone_number: message.data.phone_number,
          data: {
            person_id: message.aggregate.id
          }
        )
      end

      # If we have an email associate it
      if message.data.email.present?
        message_service.create_once_for_trace!(
          schema: Events::PersonAssociatedToEmail::V1,
          trace_id: message.trace_id,
          email: message.data.email,
          data: {
            person_id: message.aggregate.id
          }
        )
      end
    end

    private

    def matching_email?(email, user_id, trace_id)
      aggregate = Aggregates::Email.new(email:)
      person_associated_email = Projectors::Aggregates::GetLast.project(
        aggregate:,
        schema: Events::PersonAssociatedToEmail::V1
      )

      return false if person_associated_email.nil?

      emit_association_event(person_associated_email.data.person_id, user_id, trace_id)

      true
    end

    def matching_phone_number?(phone_number, user_id, trace_id)
      aggregate = Aggregates::Phone.new(phone_number:)
      person_associated_email = Projectors::Aggregates::GetLast.project(
        aggregate:,
        schema: Events::PersonAssociatedToPhoneNumber::V1
      )

      return false if person_associated_email.nil?

      emit_association_event(person_associated_email.data.person_id, user_id, trace_id)

      true
    end

    def emit_association_event(person_id, user_id, trace_id)
      return if user_id.nil?

      person_associated_user = Projectors::Aggregates::GetLast.project(
        aggregate: Aggregates::Person.new(person_id:),
        schema: Events::PersonAssociatedToPhoneNumber::V1
      )

      if person_associated_user.present?
        emit_already_associated_to_user(person_id, user_id, trace_id)
      else
        emit_associated_to_user(person_id, user_id, trace_id)
      end
    end

    def emit_associated_to_user(person_id, user_id, trace_id)
      message_service.create_once_for_trace!(
        schema: Events::PersonAssociatedToUser::V1,
        trace_id:,
        person_id:,
        data: {
          user_id:
        }
      )
    end

    def emit_already_associated_to_user(person_id, user_id, trace_id)
      message_service.create_once_for_trace!(
        schema: Events::PersonAlreadyAssociatedToUser::V1,
        trace_id:,
        person_id:,
        data: {
          user_id:
        }
      )
    end
  end
end

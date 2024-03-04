module Commands
  module NotifyEmployerOfApplicant
    module Data
      class V1
        extend Messages::Payload

        schema do
          employment_title String
          recepent_email String

          certified_by Either(String, nil), default: nil
          applicant_first_name String
          applicant_last_name String
          applicant_seeker_id Uuid
          applicant_email String
          applicant_phone_number Either(String, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Applicant,
      message_type: Messages::Types::Contact::NOTIFY_EMPLOYER_OF_APPLICANT,
      version: 1
    )
  end
end

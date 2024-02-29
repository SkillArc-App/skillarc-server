module Commands
  module SendWeeklyEmployerUpdate
    module SummaryApplicant
      class V1
        extend Messages::Payload

        schema do
          first_name String
          last_name String
          certified_by Either(String, nil), default: nil
        end
      end
    end

    module Data
      class V1
        extend Messages::Payload

        schema do
          employer_name String
          recepent_email String

          new_applicants ArrayOf(SummaryApplicant::V1)
          pending_applicants ArrayOf(SummaryApplicant::V1)
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      message_type: Messages::Types::Contact::SEND_WEEKLY_EMPLOYER_UPDATE,
      version: 1
    )
  end
end

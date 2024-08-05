module PeopleSearch
  class PeopleQuery < MessageConsumer
    include MessageEmitter

    def search(search_terms:, attributes:, user:, utm_source:)
      people_ids = Person.where("search_vector ilike '%#{search_terms}%'").pluck(:id)

      emit_event(search_terms, attributes || {}, user, utm_source)

      people_ids
    end

    private

    def emit_event(search_terms, attributes, user, _utm_source)
      with_message_service do
        message_service.create!(
          schema: Events::PersonSearchExecuted::V1,
          person_search_id: user.id,
          data: {
            search_terms:,
            attributes:
          }
        )
      end
    end
  end
end

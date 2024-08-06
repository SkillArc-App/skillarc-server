module PeopleSearch
  class PeopleQuery < MessageConsumer
    include MessageEmitter

    def search(search_terms:, user:, attributes:)
      people = if attributes.empty?
                 Person.all
               else
                 Person
                   .joins(attributes_people: :person_attribute)
                   .where(person_attribute: { attribute_id: attributes.keys, value: attributes.values.flatten })
                   .group('people_search_people.id')
                   .having("COUNT(DISTINCT person_attribute.attribute_id) = #{attributes.keys.length}")
               end

      people = Person.where("search_vector ilike '%#{search_terms}%'") if search_terms.present?

      emit_event(search_terms, attributes, user)

      people.pluck(:id)
    end

    private

    def emit_event(search_terms, attributes, user)
      with_message_service do
        message_service.create!(
          schema: Events::PersonSearchExecuted::V3,
          user_id: user.id,
          data: {
            search_terms:,
            attributes: attributes.map do |key, values|
              Events::PersonSearchExecuted::Attribute::V1.new(
                id: key,
                values:
              )
            end
          }
        )
      end
    end
  end
end

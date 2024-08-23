module PeopleSearch
  class PeopleQuery
    def self.search(search_terms:, user:, attributes:, message_service:)
      people = if attributes.empty?
                 Person.all
               else
                 Person
                   .joins(attributes_people: :person_attribute)
                   .where(person_attribute: { attribute_id: attributes.keys, value: attributes.values.flatten })
                   .group('people_search_people.id')
                   .having("COUNT(DISTINCT person_attribute.attribute_id) = ?", attributes.keys.length)
               end

      people = people.where("search_vector ilike ?", "%#{search_terms}%") if search_terms.present?

      message_service.create!(
        schema: Users::Events::PersonSearchExecuted::V3,
        user_id: user.id,
        data: {
          search_terms:,
          attributes: attributes.map do |key, values|
            Users::Events::PersonSearchExecuted::Attribute::V1.new(
              id: key,
              values:
            )
          end
        }
      )

      people.pluck(:id)
    end
  end
end

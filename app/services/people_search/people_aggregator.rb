module PeopleSearch
  class PeopleAggregator < MessageConsumer
    def reset_for_replay
      Attribute.delete_all
      AttributePerson.delete_all
      Note.delete_all
      PersonExperience.delete_all
      PersonEducationExperience.delete_all
      Person.delete_all
    end

    on_message People::Events::PersonAdded::V1 do |message|
      person = Person.new
      person.id = message.stream.id
      person.first_name = message.data.first_name
      person.last_name = message.data.last_name
      person.email = message.data.email
      person.phone_number = message.data.phone_number
      person.date_of_birth = message.data.date_of_birth

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message People::Events::BasicInfoAdded::V1 do |message|
      person = find_person_for_search_vector(message.stream.id)

      person.first_name = message.data.first_name
      person.last_name = message.data.last_name
      person.email = message.data.email || person.email
      person.phone_number = message.data.phone_number || person.phone_number

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message People::Events::CoachAssigned::V3 do |message|
      Person.update!(
        message.stream.id,
        assigned_coach_id: message.data.coach_id
      )
    end

    on_message People::Events::PersonAttributeAdded::V1 do |message|
      attributes = Attribute.where(attribute_id: message.data.attribute_id, value: message.data.attribute_values).to_a

      current_values = attributes.map(&:value)
      add_values = message.data.attribute_values - current_values

      if add_values.present?
        new_attributes = Attribute.create!(
          add_values.map do |value|
            {
              value:,
              attribute_id: message.data.attribute_id
            }
          end
        )

        attributes = new_attributes + attributes
      end

      person_attributes = AttributePerson.where(id: message.data.id)
      current_ids = person_attributes.map(&:attribute_id)
      new_ids = attributes.map(&:id)

      add_ids = new_ids - current_ids
      delete_ids = current_ids - new_ids

      if add_ids.present?
        AttributePerson.create!(
          add_ids.map do |attribute_id|
            {
              id: message.data.id,
              person_id: message.stream.id,
              attribute_id:
            }
          end
        )
      end

      AttributePerson.where(id: message.data.id, person_id: message.stream.id, attribute_id: delete_ids).delete_all if delete_ids.present?
    end

    on_message People::Events::PersonAttributeRemoved::V1 do |message|
      AttributePerson.where(id: message.data.id).delete_all
    end

    on_message People::Events::ExperienceAdded::V2 do |message|
      person = find_person_for_search_vector(message.stream.id)

      experience = person.experiences.find_or_initialize_by(id: message.data.id)

      experience.description = message.data.description
      experience.organization_name = message.data.organization_name
      experience.position = message.data.position

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message People::Events::ExperienceRemoved::V2 do |message|
      person = find_person_for_search_vector(message.stream.id)

      person.experiences.find(message.data.id).delete

      person.search_vector = search_vector(person.reload)

      person.save!
    end

    on_message People::Events::EducationExperienceAdded::V2 do |message|
      person = find_person_for_search_vector(message.stream.id)

      education_experience = person.education_experiences.find_or_initialize_by(id: message.data.id)

      education_experience.title = message.data.title
      education_experience.organization_name = message.data.organization_name
      education_experience.activities = message.data.activities

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message People::Events::EducationExperienceDeleted::V2 do |message|
      person = find_person_for_search_vector(message.stream.id)

      person.education_experiences.find(message.data.id).delete

      person.search_vector = search_vector(person.reload)

      person.save!
    end

    on_message People::Events::NoteAdded::V4 do |message|
      person = find_person_for_search_vector(message.stream.id)

      person.notes.create!(
        id: message.data.note_id,
        note: message.data.note
      )

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message People::Events::NoteModified::V4 do |message|
      Note.update!(
        message.data.note_id,
        note: message.data.note
      )

      person = find_person_for_search_vector(message.stream.id)
      person.search_vector = search_vector(person)
      person.save!
    end

    on_message People::Events::NoteDeleted::V4 do |message|
      Note.delete(message.data.note_id)

      person = find_person_for_search_vector(message.stream.id)
      person.search_vector = search_vector(person)
      person.save!
    end

    private

    def find_person_for_search_vector(id)
      Person.includes(:experiences, :education_experiences, :notes).find(id)
    end

    def search_vector(person)
      vector = [
        person.first_name,
        person.last_name,
        person.email,
        person.phone_number,
        person.date_of_birth
      ]

      person.experiences.each do |experience|
        vector << experience.organization_name
        vector << experience.position
        vector << experience.description
      end

      person.education_experiences.each do |education_experience|
        vector << education_experience.organization_name
        vector << education_experience.title
        vector << education_experience.activities
      end

      person.notes.each do |note|
        vector << note.note
      end

      vector.join(" ")
    end
  end
end

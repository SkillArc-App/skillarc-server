module PeopleSearch
  class PeopleAggregator < MessageConsumer
    def reset_for_replay
      Coach.delete_all
      PersonExperience.delete_all
      PersonEducationExperience.delete_all
      Person.delete_all
    end

    on_message Events::PersonAdded::V1 do |message|
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

    on_message Events::BasicInfoAdded::V1 do |message|
      person = find_person_for_search_vector(message.stream.id)

      person.first_name = message.data.first_name
      person.last_name = message.data.last_name
      person.email = message.data.email || person.email
      person.phone_number = message.data.phone_number || person.phone_number

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message Events::CoachAssigned::V3 do |message|
      Person.update!(
        message.stream.id,
        assigned_coach_id: message.data.coach_id
      )
    end

    on_message Events::AttributeCreated::V1 do |message|
      Attribute.create!(
        message.data.set.map do |value|
          {
            value:,
            attribute_id: message.stream.id
          }
        end
      )
    end

    on_message Events::AttributeUpdated::V1 do |message|
      attributes = Attribute.where(attribute_id: message.stream.id)
      current_values = attributes.map(&:value)
      new_values = message.data.set

      add_values = new_values - current_values
      remove_values = current_values - new_values

      Attribute.where(attribute_id: message.stream.id, value: remove_values).delete_all
      Attribute.create!(
        add_values.map do |value|
          {
            value:,
            attribute_id: message.stream.id
          }
        end
      )
    end

    on_message Events::AttributeDeleted::V1 do |message|
      Attribute.where(attribute_id: message.stream.id).delete_all
    end

    on_message Events::PersonAttributeAdded::V1 do |message|
      attribute_values = Attribute.where(attribute_id: message.data.attribute_id, value: message.data.attribute_values)

      AttributePerson.where(id: message.data.id).delete_all
      AttributePerson.create!(
        attribute_values.map do |a|
          {
            id: message.data.id,
            person_id: message.stream.id,
            attribute_id: a.id
          }
        end
      )
    end

    on_message Events::PersonAttributeRemoved::V1 do |message|
      AttributePerson.where(id: message.data.id).delete_all
    end

    on_message Events::ExperienceAdded::V2 do |message|
      person = find_person_for_search_vector(message.stream.id)

      experience = person.experiences.find_or_initialize_by(id: message.data.id)

      experience.description = message.data.description
      experience.organization_name = message.data.organization_name
      experience.position = message.data.position

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message Events::ExperienceRemoved::V2 do |message|
      person = find_person_for_search_vector(message.stream.id)

      person.experiences.find(message.data.id).delete

      person.search_vector = search_vector(person.reload)

      person.save!
    end

    on_message Events::EducationExperienceAdded::V2 do |message|
      person = find_person_for_search_vector(message.stream.id)

      education_experience = person.education_experiences.find_or_initialize_by(id: message.data.id)

      education_experience.title = message.data.title
      education_experience.organization_name = message.data.organization_name
      education_experience.activities = message.data.activities

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message Events::EducationExperienceDeleted::V2 do |message|
      person = find_person_for_search_vector(message.stream.id)

      person.education_experiences.find(message.data.id).delete

      person.search_vector = search_vector(person.reload)

      person.save!
    end

    on_message Events::NoteAdded::V4 do |message|
      person = find_person_for_search_vector(message.stream.id)

      person.notes.create!(
        id: message.data.note_id,
        note: message.data.note
      )

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message Events::NoteModified::V4 do |message|
      Note.update!(
        message.data.note_id,
        note: message.data.note
      )

      person = find_person_for_search_vector(message.stream.id)
      person.search_vector = search_vector(person)
      person.save!
    end

    on_message Events::NoteDeleted::V4 do |message|
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

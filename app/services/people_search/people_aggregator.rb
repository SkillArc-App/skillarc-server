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

    on_message Events::CoachAdded::V1 do |message|
      Coach.create!(
        id: message.data.coach_id,
        email: message.data.email
      )
    end

    on_message Events::CoachAssigned::V3 do |message|
      Person.update!(
        message.stream.id,
        assigned_coach_id: message.data.coach_id
      )
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

      person.experiences.find(message.data.id).destroy!

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

      person.education_experiences.find(message.data.id).destroy!

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
      Note.destroy(message.data.note_id)

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

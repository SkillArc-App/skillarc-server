module PeopleSearch
  class PeopleAggregator < MessageConsumer
    def reset_for_replay
      Person.delete_all
    end

    on_message Events::PersonAdded::V1 do |message|
      person = Person.new
      person.id = message.aggregate.id
      person.first_name = message.data.first_name
      person.last_name = message.data.last_name
      person.email = message.data.email
      person.phone_number = message.data.phone_number
      person.date_of_birth = message.data.date_of_birth

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message Events::BasicInfoAdded::V1 do |message|
      person = find_person(message.aggregate.id)

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
      person = find_person(message.aggregate.id)

      coach = Coach.find(message.data.coach_id)

      person.assigned_coach = coach.email

      person.save!
    end

    on_message Events::ExperienceAdded::V2 do |message|
      person = find_person(message.aggregate.id)

      person.experiences.new(
        description: message.data.description,
        organization_name: message.data.organization_name,
        position: message.data.position
      )

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message Events::ExperienceRemoved::V2 do |message|
      person = find_person(message.aggregate.id)

      person.experiences.find(message.data.id).destroy!

      person.search_vector = search_vector(person.reload)

      person.save!
    end

    on_message Events::EducationExperienceAdded::V2 do |message|
      person = find_person(message.aggregate.id)

      person.education_experiences.new(
        id: message.data.id,
        title: message.data.title,
        organization_name: message.data.organization_name,
        activities: message.data.activities
      )

      person.search_vector = search_vector(person)

      person.save!
    end

    on_message Events::EducationExperienceDeleted::V2 do |message|
      person = find_person(message.aggregate.id)

      person.education_experiences.find(message.data.id).destroy!

      person.search_vector = search_vector(person.reload)

      person.save!
    end

    private

    def find_person(id)
      Person.includes(:experiences, :education_experiences).find(id)
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

      vector.join(" ")
    end
  end
end

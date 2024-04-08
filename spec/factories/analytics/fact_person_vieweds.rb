FactoryBot.define do
  factory :analytics__fact_person_viewed, class: "Analytics::FactPersonViewed" do
    association :dim_person_viewed, factory: :analytics__dim_person
    association :dim_person_viewer, factory: :analytics__dim_person

    viewed_at { Time.zone.local(2022, 4, 1) }
  end
end

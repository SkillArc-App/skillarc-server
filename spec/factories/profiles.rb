FactoryBot.define do
  factory :profile do
    user

    id { SecureRandom.uuid }
    bio { "I'm Mary and I'm a good worker" }
    image { "www.images.com/my_image/123" }
    met_career_coach { false }
    status { nil } # column unused
  end
end

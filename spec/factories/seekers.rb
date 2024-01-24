FactoryBot.define do
  factory :seeker do
    user

    id { SecureRandom.uuid }
    bio { "I'm Mary and I'm a good worker" }
    image { "www.images.com/my_image/123" }
  end
end

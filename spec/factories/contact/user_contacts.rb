FactoryBot.define do
  factory :contact__user_contact, class: 'Contact::UserContact' do
    user_id { SecureRandom.uuid }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    slack_id { "123" }
    preferred_contact { "email" }
  end
end

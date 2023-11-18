FactoryBot.define do
  factory :chat_message do
    applicant_chat 
    user

    message { Faker::Lorem.paragraph }
  end
end

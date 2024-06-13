FactoryBot.define do
  factory :user_role do
    association :user
    role { Role::Types::COACH }
  end
end

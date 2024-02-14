FactoryBot.define do
  factory :employers_recruiter, class: 'Employers::Recruiter' do
    association :employer, factory: :employers_employer

    email { Faker::Internet.email }
  end
end

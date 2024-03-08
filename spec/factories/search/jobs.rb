FactoryBot.define do
  factory :search__job, class: "Search::Job" do
    job_id { SecureRandom.uuid }
    hidden { false }
    employment_type { Job::EmploymentTypes::PARTTIME }
    category { Job::Categories::STAFFING }
    location { "Columbus, OH" }
    tags { ["Cool Job!"] }

    employer_id { SecureRandom.uuid }
    employer_name { Faker::Company.name }
    employment_title { Faker::Job.title }
    industries { [Job::Industries::MANUFACTURING] }
  end
end

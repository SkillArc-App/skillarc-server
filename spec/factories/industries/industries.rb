FactoryBot.define do
  factory :industries__industry, class: "Industries::Industry" do
    industries { %w[construction manufacturing healthcare logistics] }
  end
end

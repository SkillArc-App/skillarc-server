FactoryBot.define do
  factory :interests__interest, class: "Interests::Interest" do
    interests { %w[construction manufacturing healthcare logistics] }
  end
end

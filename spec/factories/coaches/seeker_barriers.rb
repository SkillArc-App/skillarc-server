FactoryBot.define do
  factory :coaches__seeker_barrier, class: "Coaches::SeekerBarrier" do
    association :coach_seeker_context, factory: :coaches__coach_seeker_context
    barrier
  end
end

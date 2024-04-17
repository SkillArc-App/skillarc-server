FactoryBot.define do
  factory :contact__message_state, class: 'Contact::MessageState' do
    message_enqueued_at { Time.zone.local(2009, 1, 1) }
    message_terminated_at { nil }
    state { Contact::MessageStates::ENQUEUED }
    message_id { SecureRandom.uuid }
  end
end

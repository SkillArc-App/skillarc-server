require 'rails_helper'

RSpec.describe Klayvio::UserUpdated do
  describe "#call" do
    let(:event) do
      build(
        :events__message,
        :user_updated,
        data: Events::Common::UntypedHashWrapper.new(
          first_name: "Tom",
          last_name: "Hanks",
          phone_number: "8155201035",
          date_of_birth: Date.new(1980, 1, 1)
        )
      )
    end
    let(:email) { "tom@blocktrainapp.com" }
    let(:occurred_at) { Date.new(2020, 1, 1) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:user_updated).with(
        email: event.data[:email],
        event_id: event.id,
        occurred_at: event.occurred_at,
        profile_attributes: {
          first_name: "Tom",
          last_name: "Hanks",
          phone_number: "+18155201035"
        },
        profile_properties: {
          date_of_birth: Date.new(1980, 1, 1)
        }
      )

      subject.call(event:)
    end
  end
end

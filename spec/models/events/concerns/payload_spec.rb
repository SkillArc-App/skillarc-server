require 'rails_helper'

RSpec.describe Events::Concerns::Payload do
  let(:parent_klass) do
    Class.new do
      extend Events::Concerns::Payload

      schema do
        child Events::ApplicantStatusUpdated::Reason::V1
        optional Either(String, Events::Common::UNDEFINED), default: Events::Common::UNDEFINED
      end
    end
  end

  describe "#to_h" do
    it "returns all defined properties" do
      id = SecureRandom.uuid
      instance = parent_klass.new(child: Events::ApplicantStatusUpdated::Reason::V1.new(id:, response: nil))

      expect(instance.to_h).to eq({ child: { id:, response: nil } })
    end
  end

  describe ".from_hash" do
    it "returns all defined properties" do
      id = SecureRandom.uuid
      instance = parent_klass.from_hash({ child: { id:, response: nil } })

      expect(instance).to eq(parent_klass.new(
                               child: Events::ApplicantStatusUpdated::Reason::V1.new(id:, response: nil),
                               optional: Events::Common::UNDEFINED
                             ))
    end
  end
end

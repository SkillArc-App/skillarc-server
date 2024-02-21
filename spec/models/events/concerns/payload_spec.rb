require 'rails_helper'

RSpec.describe Events::Concerns::Payload do
  let(:parent_klass) do
    Class.new do
      extend Events::Concerns::Payload

      schema do
        child ArrayOf(Events::ApplicantStatusUpdated::Reason::V1)
        stringChild ArrayOf(String)
        optional Either(String, Messages::UNDEFINED), default: Messages::UNDEFINED
      end
    end
  end

  describe "#to_h" do
    it "returns all defined properties" do
      id = SecureRandom.uuid
      instance = parent_klass.new(stringChild: ['cat'], child: [Events::ApplicantStatusUpdated::Reason::V1.new(id:, response: nil)])

      expect(instance.to_h).to eq({ stringChild: ['cat'], child: [{ id:, response: nil }] })
    end
  end

  describe ".from_hash" do
    it "returns all defined properties" do
      id = SecureRandom.uuid
      instance = parent_klass.from_hash({ stringChild: ['cat'], child: [{ id:, response: nil }] })

      expect(instance).to eq(parent_klass.new(
                               child: [Events::ApplicantStatusUpdated::Reason::V1.new(id:, response: nil)],
                               stringChild: ['cat'],
                               optional: Messages::UNDEFINED
                             ))
    end
  end
end

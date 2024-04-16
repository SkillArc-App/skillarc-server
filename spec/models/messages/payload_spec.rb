require 'rails_helper'

RSpec.describe Messages::Payload do
  let(:parent_klass) do
    Class.new do
      extend Messages::Payload

      schema do
        child ArrayOf(Events::ApplicantStatusUpdated::Reason::V1)
        stringChild ArrayOf(String)
        optional Either(String, Messages::UNDEFINED), default: Messages::UNDEFINED
      end
    end
  end

  describe "#serialize" do
    it "returns all defined properties" do
      id = SecureRandom.uuid
      instance = parent_klass.new(stringChild: ['cat'], child: [Events::ApplicantStatusUpdated::Reason::V1.new(id:, response: nil)])

      expect(instance.serialize).to eq({ stringChild: ['cat'], child: [{ id:, response: nil }] })
    end
  end

  describe ".deserialize" do
    it "returns all defined properties" do
      id = SecureRandom.uuid
      instance = parent_klass.deserialize({ stringChild: ['cat'], child: [{ id:, response: nil }] })

      expect(instance).to eq(parent_klass.new(
                               child: [Events::ApplicantStatusUpdated::Reason::V1.new(id:, response: nil)],
                               stringChild: ['cat'],
                               optional: Messages::UNDEFINED
                             ))
    end
  end
end

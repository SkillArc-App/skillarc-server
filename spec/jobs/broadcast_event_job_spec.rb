require 'rails_helper'

RSpec.describe BroadcastEventJob do
  it "calls PubSub publish" do
    schema_string = Events::UserCreated::Data::V1.to_s

    expect(PUBSUB)
      .to receive(:publish)
      .with(schema_string:)
      .and_call_original

    described_class.new.perform(schema_string)
  end
end

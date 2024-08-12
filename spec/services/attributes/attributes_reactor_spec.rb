require 'rails_helper'

RSpec.describe Attributes::AttributesReactor do
  it_behaves_like "a non replayable message consumer"

  let(:message_service) { MessageService.new }
  let(:consumer) { described_class.new(message_service:) }
end

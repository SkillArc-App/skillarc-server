require 'rails_helper'

RSpec.describe TrainingProviders::TrainingProviderReactor do
  it_behaves_like "a replayable message consumer"

  let(:instance) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
end

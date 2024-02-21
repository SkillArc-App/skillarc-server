RSpec.shared_examples "an event consumer" do
  describe ".handle_event" do
    subject { described_class.handle_event(message) }

    let(:message) { build(:message, :role_added) }

    it "does not raise an error" do
      expect { subject }.not_to raise_error
    end
  end

  describe ".reset_for_replay" do
    subject { described_class.reset_for_replay }

    it "does not raise an error" do
      expect { subject }.not_to raise_error
    end
  end
end

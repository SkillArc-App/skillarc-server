RSpec.shared_examples "an event consumer" do
  describe ".handle_event" do
    subject { described_class.handle_event(event) }

    let(:event) { build(:events__message, :role_added) }

    it "does not raise an error" do
      expect { subject }.not_to raise_error
    end
  end
end

RSpec.shared_examples "an event consumer" do
  describe ".reset_for_replay" do
    subject { described_class.new.reset_for_replay }

    it "does not raise an error" do
      expect { subject }.not_to raise_error
    end
  end
end

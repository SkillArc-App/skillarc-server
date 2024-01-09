require 'rails_helper'

RSpec.describe "Notes", type: :request do
  describe "POST /:seeker_id/notes" do
    subject { post seeker_notes_path(seeker_id), params:, headers: }

    let(:seeker_id) { SecureRandom.uuid }
    let(:params) do
      {
        note: "This is a note"
      }
    end

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      context "when a note id is included in the body" do
        let(:params) do
          {
            note: "This is a note",
            id: "123"
          }
        end

        it "calls CoachSeekers.create_note" do
          expect(CoachSeekers)
            .to receive(:add_note)
            .with(seeker_id, params[:note], params[:id])
            .and_call_original

          subject
        end
      end

      context "when a note id is not included in the body" do
        it "calls CoachSeekers.create_note" do
          expect(CoachSeekers)
            .to receive(:add_note)
            .with(seeker_id, params[:note], be_a(String))
            .and_call_original

          subject
        end
      end
    end
  end
end

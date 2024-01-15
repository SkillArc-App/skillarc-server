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
            note_id: "123"
          }
        end

        it "calls SeekerService.create_note" do
          expect(Coaches::SeekerService)
            .to receive(:add_note)
            .with(seeker_id, params[:note], params[:note_id])
            .and_call_original

          subject
        end
      end

      context "when a note id is not included in the body" do
        it "calls SeekerService.create_note" do
          expect(Coaches::SeekerService)
            .to receive(:add_note)
            .with(seeker_id, params[:note], be_a(String))
            .and_call_original

          subject
        end
      end
    end
  end

  describe "PUT /:seeker_id/notes/:note_id" do
    subject { put seeker_note_path(seeker_id, note_id), params:, headers: }

    let(:seeker_id) { SecureRandom.uuid }
    let(:note_id) { SecureRandom.uuid }

    let(:params) do
      {
        note: "This is a updated note"
      }
    end

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.modify_note" do
        expect(Coaches::SeekerService)
          .to receive(:modify_note)
          .with(seeker_id, note_id, params[:note])
          .and_call_original

        subject
      end
    end
  end

  describe "DELETE /:seeker_id/notes/:note_id" do
    subject { delete seeker_note_path(seeker_id, note_id), headers: }

    let(:seeker_id) { SecureRandom.uuid }
    let(:note_id) { SecureRandom.uuid }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.delete_note" do
        expect(Coaches::SeekerService)
          .to receive(:delete_note)
          .with(seeker_id, note_id)
          .and_call_original

        subject
      end
    end
  end
end

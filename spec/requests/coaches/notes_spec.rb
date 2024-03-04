require 'rails_helper'

RSpec.describe "Notes", type: :request do
  describe "POST /:seeker_id/notes" do
    subject { post seeker_notes_path(seeker_id), params:, headers: }

    let(:seeker_id) { coach_seeker_context.seeker_id }
    let(:params) do
      {
        note: "This is a note"
      }
    end
    let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      context "when a note id is included in the body" do
        let(:params) do
          {
            note: "This is a note",
            note_id: SecureRandom.uuid
          }
        end

        it "calls SeekerService.create_note" do
          expect_any_instance_of(Coaches::SeekerService)
            .to receive(:add_note)
            .with(
              seeker_id:,
              coach:,
              note: params[:note],
              note_id: params[:note_id]
            )
            .and_call_original

          subject
        end
      end

      context "when a note id is not included in the body" do
        it "calls SeekerService.create_note" do
          expect_any_instance_of(Coaches::SeekerService)
            .to receive(:add_note)
            .with(
              coach:,
              seeker_id:,
              note: params[:note],
              note_id: be_a(String)
            )
            .and_call_original

          subject
        end
      end
    end
  end

  describe "PUT /:seeker_id/notes/:note_id" do
    subject { put seeker_note_path(seeker_id, note_id), params:, headers: }

    let(:seeker_id) { coach_seeker_context.seeker_id }
    let(:note_id) { seeker_note.note_id }

    let(:params) do
      {
        note: "This is a updated note"
      }
    end
    let(:seeker_note) { create(:coaches__seeker_note, coach_seeker_context:) }
    let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.modify_note" do
        expect_any_instance_of(Coaches::SeekerService)
          .to receive(:modify_note)
          .with(
            seeker_id:,
            coach:,
            note_id:,
            note: params[:note]
          )
          .and_call_original

        subject
      end
    end
  end

  describe "DELETE /:seeker_id/notes/:note_id" do
    subject { delete seeker_note_path(seeker_id, note_id), headers: }

    let(:seeker_id) { coach_seeker_context.seeker_id }
    let(:note_id) { seeker_note.note_id }

    let(:seeker_note) { create(:coaches__seeker_note, coach_seeker_context:) }
    let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.delete_note" do
        expect_any_instance_of(Coaches::SeekerService)
          .to receive(:delete_note)
          .with(
            seeker_id:,
            coach:,
            note_id:
          )
          .and_call_original

        subject
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Coaches::CoachAssignmentService do
  describe ".round_robin_assignment" do
    subject do
      described_class.round_robin_assignment
    end

    let!(:coach1) { create(:coaches__coach, assignment_weight: 1.0) }
    let!(:coach2) { create(:coaches__coach, assignment_weight: 0.5) }

    context "if there are no coaches" do
      let!(:coach1) { nil }
      let!(:coach2) { nil }

      it "raiises a NoCoachesError" do
        expect { subject }.to raise_error(described_class::NoCoachesError)
      end
    end

    context "when there are no assigned coach seeker context with in the lookback period" do
      context "when the assignments is too old" do
        before do
          create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: 1.year.ago)
          create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: 1.year.ago)
        end

        it "returns the coach with the highest weight" do
          expect(subject).to eq(coach1)
        end
      end

      context "when the assignemnt is in the window but not assigned" do
        before do
          create(:coaches__coach_seeker_context, assigned_coach: nil, seeker_captured_at: Time.zone.now)
          create(:coaches__coach_seeker_context, assigned_coach: nil, seeker_captured_at: Time.zone.now)
        end

        it "returns the coach with the highest weight" do
          expect(subject).to eq(coach1)
        end
      end
    end

    context "when one coach has all of the assignments" do
      before do
        create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: Time.zone.now)
      end

      it "returns the other coach" do
        expect(subject).to eq(coach2)
      end
    end

    context "when both coaches have assignments" do
      context "scenario 1" do
        before do
          create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: Time.zone.now)
          create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: Time.zone.now)
          create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: Time.zone.now)
          create(:coaches__coach_seeker_context, assigned_coach: coach2.email, seeker_captured_at: Time.zone.now)
        end

        it "returns coach furthest from target" do
          expect(subject).to eq(coach2)
        end
      end

      context "scenario 2" do
        before do
          create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: Time.zone.now)
          create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: Time.zone.now)
          create(:coaches__coach_seeker_context, assigned_coach: coach1.email, seeker_captured_at: Time.zone.now)
          create(:coaches__coach_seeker_context, assigned_coach: coach2.email, seeker_captured_at: Time.zone.now)
          create(:coaches__coach_seeker_context, assigned_coach: coach2.email, seeker_captured_at: Time.zone.now)
        end

        it "returns coach furthest from target" do
          expect(subject).to eq(coach1)
        end
      end
    end
  end
end

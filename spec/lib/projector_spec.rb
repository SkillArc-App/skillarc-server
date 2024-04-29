require 'rails_helper'

RSpec.describe Projector do
  describe ".on_message" do
    context "when no aggregate is given" do
      let(:sub_klass) do
        Class.new(described_class) do
          on_message Events::SessionStarted::V1 do |_|
            true
          end
        end
      end

      it "raises a NoAggregateError" do
        expect { sub_klass }.to raise_error(described_class::NoAggregateError)
      end
    end

    context "when the aggregate and on_message aggregate don't align" do
      let(:sub_klass) do
        Class.new(described_class) do
          projection_aggregator Aggregates::Coach

          on_message Events::SessionStarted::V1 do |_|
            true
          end
        end
      end

      it "raises a NotCorrectAggregateError" do
        expect { sub_klass }.to raise_error(described_class::NotCorrectAggregateError)
      end
    end
  end

  describe ".project" do
    context "when the project aggregate and the provided aggregate don't match" do
      let(:sub_klass) do
        Class.new(described_class) do
          projection_aggregator Aggregates::User
        end
      end

      it "raises a WrongAggregatorError" do
        expect { sub_klass.project(aggregate: Aggregates::Coach.new(coach_id: SecureRandom.uuid)) }.to raise_error(described_class::WrongAggregatorError)
      end
    end

    context "when called without an init method" do
      let(:sub_klass) do
        Class.new(described_class) do
          projection_aggregator Aggregates::User
        end
      end

      it "raises a WrongAggregatorError" do
        expect { sub_klass.project(aggregate: Aggregates::User.new(user_id: SecureRandom.uuid)) }.to raise_error(NoMethodError)
      end
    end

    context "when the reduces changes the accumulation type" do
      before do
        Event.from_message!(
          build(
            :message,
            schema: Events::SessionStarted::V1,
            aggregate_id: user_id,
            data: Messages::Nothing
          )
        )
      end

      let(:sub_klass) do
        Class.new(described_class) do
          projection_aggregator Aggregates::User

          def init
            10
          end

          on_message Events::SessionStarted::V1 do |m, accumulator|
            accumulator.to_s + m.trace_id
          end
        end
      end

      let(:user_id) { SecureRandom.uuid }

      it "raises a AccumulatorChangedError" do
        expect { sub_klass.project(aggregate: Aggregates::User.new(user_id:)) }.to raise_error(described_class::AccumulatorChangedError)
      end
    end

    context "when everything works" do
      before do
        count.times do
          Event.from_message!(
            build(
              :message,
              schema: Events::SessionStarted::V1,
              aggregate_id: user_id,
              data: Messages::Nothing
            )
          )
        end
      end

      let(:sub_klass) do
        Class.new(described_class) do
          projection_aggregator Aggregates::User

          def init
            0
          end

          on_message Events::SessionStarted::V1 do |_m, accumulator|
            accumulator + 1
          end
        end
      end
      let(:count) { 15 }
      let(:user_id) { SecureRandom.uuid }

      it "returns the projection value" do
        expect(sub_klass.project(aggregate: Aggregates::User.new(user_id:))).to eq(count)
      end
    end
  end
end

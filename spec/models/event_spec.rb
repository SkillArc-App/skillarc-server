require 'rails_helper'

RSpec.describe Event do
  describe "#message" do
    subject { event.message }

    let(:id) { SecureRandom.uuid }
    let(:event) do
      build(
        :event,
        version: Events::JobSearch::V1.version,
        event_type: Events::JobSearch::V1.event_type,
        data: {
          search_terms: "Cool job",
          tags: nil,
          industries: ['Red Industry', 'Lame Industry']
        },
        metadata: {
          source: "seeker",
          id:
        }
      )
    end

    it "creates an Events::Message with the same data" do
      expect(subject).to be_a(Events::Message)

      expect(subject.id).to eq(event[:id])
      expect(subject.aggregate_id).to eq(event[:aggregate_id])
      expect(subject.event_type).to eq(event[:event_type])
      expect(subject.data).to eq(Events::JobSearch::Data::V1.new(
                                   search_terms: "Cool job",
                                   tags: nil,
                                   industries: ['Red Industry', 'Lame Industry']
                                 ))
      expect(subject.metadata).to eq(Events::JobSearch::MetaData::V1.new(
                                       id:,
                                       source: "seeker"
                                     ))
      expect(subject.version).to eq(event[:version])
      expect(subject.occurred_at).to eq(event[:occurred_at])
    end
  end

  describe ".from_message!" do
    subject { described_class.from_message!(events__message) }

    let(:id) { SecureRandom.uuid }
    let(:events__message) do
      build(
        :events__message,
        version: Events::JobSearch::V1.version,
        event_type: Events::JobSearch::V1.event_type,
        data: Events::JobSearch::Data::V1.new(
          search_terms: "Cool job",
          tags: nil,
          industries: ['Red Industry', 'Lame Industry']
        ),
        metadata: Events::JobSearch::MetaData::V1.new(
          id:,
          source: "seeker"
        )
      )
    end

    it "creates an Events::Message with the same data" do
      expect(subject).to be_a(described_class)

      expect(subject[:id]).to eq(events__message.id)
      expect(subject[:aggregate_id]).to eq(events__message.aggregate_id)
      expect(subject[:event_type]).to eq(events__message.event_type)
      expect(subject[:data].deep_symbolize_keys).to eq({
                                                         search_terms: "Cool job",
                                                         tags: nil,
                                                         industries: ['Red Industry', 'Lame Industry']
                                                       })
      expect(subject[:metadata].deep_symbolize_keys).to eq({
                                                             source: "seeker",
                                                             id:
                                                           })
      expect(subject[:version]).to eq(events__message.version)
      expect(subject[:occurred_at]).to eq(events__message.occurred_at)
    end
  end
end

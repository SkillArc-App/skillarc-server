module Jobs
  class SearchService
    def initialize(search_terms:, industries:, tags:)
      @search_terms = search_terms
      @industries = industries
      @tags = tags
    end

    def relevant_jobs(search_source:)
      query = Job.for_search

      query = query.where("employment_title LIKE ?", "%#{search_terms}%") if search_terms_usable?
      query = query.where("industry && ARRAY[?]::text[]", industries) if industries_usable?
      query = query.where(tags: { name: tags }) if tags_usable?

      emit_event(search_source)

      query
    end

    private

    attr_reader :search_terms, :industries, :tags

    def emit_event(search_source)
      case search_source
      when Seeker
        aggregate_id = search_source.id
        metadata = Events::JobSearch::MetaData::V1.new(
          source: "seeker",
          id: search_source.id
        )
      else
        aggregate_id = "non-seeker"
        metadata = Events::JobSearch::MetaData::V1.new(
          source: "non-seeker"
        )
      end

      EventService.create!(
        event_schema: Events::JobSearch::V1,
        data: Events::JobSearch::Data::V1.new(
          search_terms:,
          industries:,
          tags:
        ),
        aggregate_id:,
        metadata:
      )
    end

    def search_terms_usable?
      search_terms.present? && search_terms.length >= 3
    end

    def industries_usable?
      industries.present?
    end

    def tags_usable?
      tags.present?
    end
  end
end

module Jobs
  class SearchService
    def initialize(search_terms:, industries:, tags:)
      @search_terms = search_terms
      @industries = industries
      @tags = tags
    end

    def relevant_jobs(user:, utm_source:)
      query = Job.for_search

      query = query.where("lower(employment_title) LIKE ?", "%#{search_terms.downcase}%") if search_terms_usable?
      query = query.where("industry && ARRAY[?]::text[]", industries) if industries_usable?
      query = query.where(tags: { name: tags }) if tags_usable?

      emit_event(user, utm_source)

      query
    end

    private

    attr_reader :search_terms, :industries, :tags

    def emit_event(user, utm_source)
      if user.present?
        source = if user.seeker.present?
                   "seeker"
                 else
                   "user"
                 end

        search_id = user.id
        metadata = Events::JobSearch::MetaData::V2.new(
          source:,
          id: user.id,
          utm_source:
        )
      else
        search_id = "unauthenticated"
        metadata = Events::JobSearch::MetaData::V2.new(
          source: "unauthenticated",
          utm_source:
        )
      end

      EventService.create!(
        event_schema: Events::JobSearch::V2,
        data: Events::JobSearch::Data::V1.new(
          search_terms:,
          industries:,
          tags:
        ),
        search_id:,
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

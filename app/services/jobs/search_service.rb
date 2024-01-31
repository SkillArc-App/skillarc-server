module Jobs
  class SearchService
    def initialize(search_terms:, industries:, tags:)
      @search_terms = search_terms
      @industries = industries
      @tags = tags
    end

    def relevant_jobs
      query = Job.shown.with_everything

      query = query.where("employment_title LIKE ?", "%#{search_terms}%") if search_terms_usable?
      query = query.where("industry && ARRAY[?]::text[]", industries) if industries_usable?
      query = query.where(tags: { name: tags }) if tags_usable?

      query
    end

    private

    attr_reader :search_terms, :industries, :tags

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

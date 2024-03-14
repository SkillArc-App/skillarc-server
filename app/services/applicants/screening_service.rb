module Applicants
  class ScreeningService
    module ScreeningResults
      ALL = [
        APPROVED = 'approved'.freeze,
        NOT_APPROVED = 'not_approved'.freeze
      ].freeze
    end

    def initialize(applicant)
      @applicant = applicant
    end

    def screen
      return ScreeningResults::APPROVED if applicant.job.marketplace?
      return ScreeningResults::APPROVED if applicant.certified_by.present?

      ScreeningResults::NOT_APPROVED
    end

    private

    attr_reader :applicant
  end
end

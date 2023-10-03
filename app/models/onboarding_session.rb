class OnboardingSession < ApplicationRecord
  def industry_interests
    # begin
    #   responses["opportunityInterests"]["response"].map(&:downcase)
    # rescue
    ['construction', 'manufacturing', 'healthcare']
    # end
  end
end
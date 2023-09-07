class OnboardingSession < ApplicationRecord
  self.table_name = "OnboardingSession"

  def industry_interests
    responses["opportunityInterests"]["response"].map(&:downcase)
  end
end
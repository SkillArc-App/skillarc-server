class OnboardingSession < ApplicationRecord
  belongs_to :user

  def industry_interests
    # begin
    #   responses["opportunityInterests"]["response"].map(&:downcase)
    # rescue
    ['construction', 'manufacturing', 'healthcare']
    # end
  end
end

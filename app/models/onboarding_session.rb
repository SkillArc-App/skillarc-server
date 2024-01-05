# == Schema Information
#
# Table name: onboarding_sessions
#
#  id           :text             not null, primary key
#  user_id      :text             not null
#  started_at   :datetime         not null
#  completed_at :datetime
#  current_step :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  responses    :jsonb            not null
#
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

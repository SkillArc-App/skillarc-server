# == Schema Information
#
# Table name: onboarding_sessions
#
#  id           :text             not null, primary key
#  completed_at :datetime
#  current_step :text
#  responses    :jsonb            not null
#  started_at   :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :text             not null
#
# Indexes
#
#  OnboardingSession_user_id_key  (user_id) UNIQUE
#
# Foreign Keys
#
#  OnboardingSession_user_id_fkey  (user_id => users.id) ON DELETE => restrict ON UPDATE => cascade
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

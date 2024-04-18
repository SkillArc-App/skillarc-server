# == Schema Information
#
# Table name: coaches_reminders
#
#  id              :uuid             not null, primary key
#  note            :string           not null
#  reminder_at     :datetime         not null
#  state           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  coach_id        :uuid             not null
#  context_id      :string
#  message_task_id :uuid             not null
#
# Indexes
#
#  index_coaches_reminders_on_coach_id  (coach_id)
#
# Foreign Keys
#
#  fk_rails_...  (coach_id => coaches.id)
#
module Coaches
  class Reminder < ApplicationRecord
    self.table_name = "coaches_reminders"

    belongs_to :coach, class_name: "Coaches::Coach"

    validates :state, inclusion: { in: ReminderState::ALL }
  end
end

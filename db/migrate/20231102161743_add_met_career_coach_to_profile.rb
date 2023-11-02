class AddMetCareerCoachToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :met_career_coach, :boolean, default: false
  end
end

class StoryDropProfileId < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :stories, :profile_id, :text }
  end
end

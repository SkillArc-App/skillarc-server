class DropSeekerApplication < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches_seeker_applications
  end
end

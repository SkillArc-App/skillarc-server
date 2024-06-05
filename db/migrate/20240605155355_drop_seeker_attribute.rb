class DropSeekerAttribute < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches_seeker_attributes
  end
end

class AddAboutToSeeker < ActiveRecord::Migration[7.0]
  def change
    add_column :seekers, :about, :text
  end
end

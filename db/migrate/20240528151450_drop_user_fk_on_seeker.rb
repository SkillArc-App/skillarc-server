class DropUserFkOnSeeker < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :seekers, :users
  end
end

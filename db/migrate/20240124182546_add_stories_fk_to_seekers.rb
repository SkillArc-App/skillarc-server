class AddStoriesFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :stories, :seekers, validate: false
  end
end

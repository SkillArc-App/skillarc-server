class DropJobAttributeColumns < ActiveRecord::Migration[7.1]
  def change
    drop_table :job_attributes # rubocop:disable Rails/ReversibleMigration
  end
end

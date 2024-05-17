class DropProgramSkill < ActiveRecord::Migration[7.1]
  def change
    drop_table :program_skills # rubocop:disable Rails/ReversibleMigration
  end
end

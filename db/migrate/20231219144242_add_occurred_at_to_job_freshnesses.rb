class AddOccurredAtToJobFreshnesses < ActiveRecord::Migration[7.0]
  def change
    add_column :job_freshnesses, :occurred_at, :datetime, null: false # rubocop:disable Rails/NotNullColumn

    change_column_null :job_freshnesses, :employer_name, null: false
  end
end

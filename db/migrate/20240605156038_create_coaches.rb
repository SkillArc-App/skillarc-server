class CreateCoaches < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_coaches, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.float :assignment_weight, null: false
      t.string :email
      t.string :user_id, null: false, index: true
    end
  end
end

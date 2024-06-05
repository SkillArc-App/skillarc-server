class AddDimUserReferenceOnFactCoachAction < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_reference :analytics_fact_coach_actions, :analytics_dim_users, index: { algorithm: :concurrently }
  end
end

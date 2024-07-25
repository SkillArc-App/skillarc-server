class AddScreenerQuestionIdToJobOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :job_orders_job_orders, :screener_questions_id, :uuid
  end
end

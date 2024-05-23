class RemoveApplicantFkOnJob < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :applicants, :jobs
  end
end

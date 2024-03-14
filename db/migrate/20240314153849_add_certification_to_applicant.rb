class AddCertificationToApplicant < ActiveRecord::Migration[7.1]
  def change
    add_column :applicants, :certified_by, :string
  end
end

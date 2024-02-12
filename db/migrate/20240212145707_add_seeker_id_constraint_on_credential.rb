class AddSeekerIdConstraintOnCredential < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :credentials, "seeker_id IS NOT NULL", name: "credentials_seeker_id_null", validate: false
  end
end

class AddSeekerIdValidateOnCredentials < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :credentials, name: "credentials_seeker_id_null"
    change_column_null :credentials, :seeker_id, false
    remove_check_constraint :credentials, name: "credentials_seeker_id_null"
  end
end

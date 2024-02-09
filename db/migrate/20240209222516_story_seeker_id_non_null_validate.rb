class StorySeekerIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :stories, name: "references_seeker_id_null"
    change_column_null :stories, :seeker_id, false
    remove_check_constraint :stories, name: "references_seeker_id_null"
  end
end

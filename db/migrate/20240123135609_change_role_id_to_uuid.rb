class ChangeRoleIdToUuid < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :roles, :uuid, :uuid, default: 'gen_random_uuid()', null: false }

    add_foreign_key :user_roles, :roles, column: :role_uuid, primary_key: :uuid
  end
end
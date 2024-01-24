class RenameProfileToSeeker < ActiveRecord::Migration[7.0]
  def change
    create_table :seekers, id: :uuid do |t|
      t.string :bio
      t.string :image
      t.references :user, null: false, foreign_key: true, type: :text

      t.timestamps
    end
  end
end

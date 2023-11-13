class CreateReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :reasons, id: :uuid do |t|
      t.string :description

      t.timestamps
    end
  end
end

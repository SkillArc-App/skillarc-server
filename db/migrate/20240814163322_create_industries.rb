class CreateIndustries < ActiveRecord::Migration[7.1]
  def change
    create_table :industries_industries do |t|
      t.string :industries, null: false, array: true
    end
  end
end

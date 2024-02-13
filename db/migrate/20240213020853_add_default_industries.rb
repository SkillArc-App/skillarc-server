class AddDefaultIndustries < ActiveRecord::Migration[7.0]
  def change
    change_column_default :jobs, :industry, from: nil, to: []
  end
end

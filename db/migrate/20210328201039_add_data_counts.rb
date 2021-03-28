class AddDataCounts < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :appointments, :integer
    add_column :cvs_cities, :appointments, :integer
    add_column :health_mart_cities, :appointments, :integer
    add_column :walgreens_cities, :appointments, :integer
    add_column :walmart_cities, :appointments, :integer
  end
end

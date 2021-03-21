class AddHealthMartToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :is_health_mart, :boolean
    add_column :locations, :name, :string
    add_index :locations, :is_health_mart
    Location.reset_column_information
  end
end

class AddWalmartToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :is_walmart, :boolean
    add_index :locations, :is_walmart
    Location.reset_column_information
  end
end

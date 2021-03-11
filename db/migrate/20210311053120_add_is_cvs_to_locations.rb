class AddIsCvsToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :is_cvs, :boolean
    add_index :locations, :is_cvs
    add_index :locations, :is_rite_aid
    add_index :locations, :is_walgreens
    Location.reset_column_information
  end
end

class AddVaccineType < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :vaccine_types, :string
    add_column :histories, :vaccine_types, :string

    add_index :histories, :is_cvs
    add_index :histories, :is_health_mart
    add_index :histories, :is_rite_aid
    add_index :histories, :is_walgreens
    add_index :histories, :is_walmart
  end
end

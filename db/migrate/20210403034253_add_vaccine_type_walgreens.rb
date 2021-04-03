class AddVaccineTypeWalgreens < ActiveRecord::Migration[6.1]
  def change
    add_column :walgreens_cities, :vaccine_types, :string
  end
end

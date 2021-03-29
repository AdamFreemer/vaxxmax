class AddDataCountsPart2 < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.integer :location_id
      t.boolean :status
      t.boolean :is_cvs
      t.boolean :is_health_mart
      t.boolean :is_rite_aid
      t.boolean :is_walgreens
      t.boolean :is_walmart
      t.string :latitude
      t.string :longitude
      t.string :city
      t.string :state
      t.string :zip
      t.string :county
      t.datetime :last_updated
      t.datetime :when_available

      t.timestamps
    end

    add_column :locations, :appointments_all, :integer
    add_column :cvs_cities, :appointments_all, :integer
    add_column :health_mart_cities, :appointments_all, :integer
    add_column :walgreens_cities, :appointments_all, :integer
    add_column :walmart_cities, :appointments_all, :integer
  end
end

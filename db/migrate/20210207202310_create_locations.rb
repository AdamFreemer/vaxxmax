class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :store_number
      t.boolean :slot_1
      t.boolean :slot_2
      t.string :status, default: 'Not Checked'
      t.string :full_address
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :latitude
      t.string :longitude
      t.string :county
      t.string :phone
      t.datetime :last_updated
      t.datetime :when_available
      t.boolean :availability

      t.timestamps
    end
  end
end

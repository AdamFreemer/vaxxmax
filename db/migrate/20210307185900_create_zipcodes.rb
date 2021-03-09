class CreateZipcodes < ActiveRecord::Migration[6.1]
  def change
    create_table :zipcodes do |t|
      t.integer :zipcode
      t.string :city
      t.string :state
      t.string :latitude
      t.string :longitude
      t.string :timezone
      t.string :dst
      t.string :geopoint1
      t.string :geopoint2

      t.timestamps
    end
  end
end

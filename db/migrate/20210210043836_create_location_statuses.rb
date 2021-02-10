class CreateLocationStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :location_statuses do |t|
      t.string :address
      t.string :store_id
      t.datetime :time
      t.timestamps
    end
  end
end

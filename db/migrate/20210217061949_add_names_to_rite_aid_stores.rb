class AddNamesToRiteAidStores < ActiveRecord::Migration[6.1]
  def change
    locations = Location.where(store_name: nil)
    locations.each do |location|
      location.store_name = "Rite Aid"
      location.save
    end
  end
end

class AddLocationAvailabilityMetric < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :store_availability_count, :integer, default: 0
  end
end

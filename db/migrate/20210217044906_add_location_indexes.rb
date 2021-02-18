class AddLocationIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :locations, :availability
    add_index :locations, :when_available
    add_index :locations, :state
  end
end

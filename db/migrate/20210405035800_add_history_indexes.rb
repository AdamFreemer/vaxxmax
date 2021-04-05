class AddHistoryIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :histories, :state
    add_index :histories, :created_at
  end
end

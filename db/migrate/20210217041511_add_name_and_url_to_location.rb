class AddNameAndUrlToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :store_name, :string
    add_column :locations, :store_url, :string
  end
end

class AddNameAndUrlToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :store_url, :string
    add_column :locations, :is_rite_aid, :boolean, default: false
    add_column :locations, :is_walgreens, :boolean, default: false
  end
end

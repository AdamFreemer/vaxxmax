class AddIsCvsToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :is_cvs, :boolean, default: false
  end
end

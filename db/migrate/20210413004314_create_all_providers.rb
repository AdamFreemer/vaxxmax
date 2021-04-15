class CreateAllProviders < ActiveRecord::Migration[6.1]
  def change
    create_view :all_providers
  end
end

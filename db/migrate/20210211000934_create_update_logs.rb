class CreateUpdateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :update_logs do |t|
      t.string :task

      t.timestamps
    end
  end
end

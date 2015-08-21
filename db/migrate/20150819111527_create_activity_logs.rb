class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.string :user_id
      t.integer :ip
      t.text :action

      t.timestamps null: false
    end
  end
end

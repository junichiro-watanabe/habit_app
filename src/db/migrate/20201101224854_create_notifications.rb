class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id
      t.integer :visited_id
      t.integer :relationship_id
      t.integer :belong_id
      t.integer :like_id
      t.integer :message_id
      t.string :action, default: ''
      t.boolean :checked, default: false

      t.timestamps
    end
      add_index :notifications, :visitor_id
      add_index :notifications, :visited_id
      add_index :notifications, :relationship_id
      add_index :notifications, :belong_id
      add_index :notifications, :like_id
      add_index :notifications, :message_id
  end
end

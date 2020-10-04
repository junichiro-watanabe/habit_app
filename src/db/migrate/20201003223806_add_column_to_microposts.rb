class AddColumnToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :encouragement, :boolean, default: false
  end
end

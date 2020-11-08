class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :habit
      t.string :overview, default: ''

      t.timestamps
    end
    add_index :groups, [:name, :habit, :overview]
  end
end

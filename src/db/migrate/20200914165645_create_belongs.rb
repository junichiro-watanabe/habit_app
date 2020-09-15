class CreateBelongs < ActiveRecord::Migration[6.0]
  def change
    create_table :belongs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
    add_index :belongs, [:user_id, :group_id], unique:true
  end
end

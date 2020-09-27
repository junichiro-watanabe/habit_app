class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.references :achievement, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
    add_index :histories, :date
    add_index :histories, [:achievement_id, :date], unique:true
  end
end

class CreateAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements do |t|
      t.references :belong, null: false, foreign_key: true, unique: true
      t.boolean :achieved, default: false

      t.timestamps
    end
  end
end

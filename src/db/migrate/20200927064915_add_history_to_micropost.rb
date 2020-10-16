class AddHistoryToMicropost < ActiveRecord::Migration[6.0]
  def change
    add_reference :microposts, :history, foreign_key: true
  end
end

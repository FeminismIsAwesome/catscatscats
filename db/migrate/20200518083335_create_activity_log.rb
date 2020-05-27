class CreateActivityLog < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_logs do |t|
      t.references :cat_game
      t.references :cat_player
      t.string :description
      t.timestamps
    end
  end
end

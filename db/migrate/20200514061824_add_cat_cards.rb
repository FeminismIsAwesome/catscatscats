class AddCatCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cat_cards do |t|
      t.string :title
      t.timestamps
    end
  end
end

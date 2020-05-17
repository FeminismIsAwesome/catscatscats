class AddPlayerQualities < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_players, :remote_id, :string
    add_column :cat_players, :food, :integer, default: 0
    add_column :cat_players, :toys, :integer, default: 0
    add_column :cat_players, :catnip, :integer, default: 0
    add_column :cat_players, :litterbox, :integer, default: 0
    add_column :cat_players, :created_at, :datetime, null: false
    add_column :cat_players, :updated_at, :datetime, null: false
  end
end

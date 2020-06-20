class AddVictoryPointsToCat < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_players, :victory_points, :integer, default: 0
    add_column :cat_players, :energy_maximum, :integer, default: 10
  end
end

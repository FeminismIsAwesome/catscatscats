class AddCatPhaseSteps < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_games, :cards_played, :jsonb, default: []
    add_column :cat_games, :players_passed, :jsonb, default: []
  end
end

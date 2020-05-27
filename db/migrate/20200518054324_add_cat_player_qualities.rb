class AddCatPlayerQualities < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_players, :owned_card_ids, :jsonb, default: []
    add_column :cat_players, :hand_card_ids, :jsonb, default: []
    add_column :cat_players, :energy_count, :integer, default: 0
    add_column :cat_players, :next_player_id, :bigint
    add_column :cat_players, :actions_provided, :jsonb
  end
end

class AddDeckQualitiesForNextPhase < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_decks, :cat_player_order, :jsonb, default: []
    create_table :owned_cats do |t|
      t.references :cat_player
      t.references :cat_card
      t.integer :happiness_level, default: 3
      t.timestamps
    end
    create_table :shelter_cats do |t|
      t.references :cat_game
      t.references :cat_card
      t.timestamps
    end
    create_table :shelter_cat_bids do |t|
      t.references :cat_player
      t.references :shelter_cat
      t.integer :bid_amount, default: 0
      t.timestamps
    end

    add_column :cat_games, :state, :string, default: 'drafting'
    add_column :cat_games, :current_player_id, :bigint
    add_column :cat_games, :bids_placed, :jsonb, default: []
  end
end

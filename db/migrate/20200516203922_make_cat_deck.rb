class MakeCatDeck < ActiveRecord::Migration[6.0]
  def change
    create_table :cat_games do |t|
      t.string :ended_at
      t.timestamps
    end

    create_table :cat_decks  do |t|
      t.references :cat_game
      t.jsonb :discard_pile
      t.jsonb :deck_pile
      t.timestamps
    end

    create_table :cat_players do |t|
      t.references :cat_game
      t.string :name
    end
  end
end

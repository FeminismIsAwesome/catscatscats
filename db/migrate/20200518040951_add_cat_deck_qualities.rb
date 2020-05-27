class AddCatDeckQualities < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_decks, :cats_discard_pile, :jsonb
    add_column :cat_decks, :cats_draw_pile, :jsonb
  end
end

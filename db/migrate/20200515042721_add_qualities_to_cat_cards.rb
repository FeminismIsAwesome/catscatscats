class AddQualitiesToCatCards < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_cards, :subtype, :string
    add_column :cat_cards, :description, :string
    add_column :cat_cards, :number_tl, :string
    add_column :cat_cards, :number_tr, :string
    add_column :cat_cards, :kind, :string
    add_column :cat_cards, :self_hosted, :boolean
    add_column :cat_cards, :tile_image, :text
  end
end

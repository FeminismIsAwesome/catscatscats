class AddCatCardQualities < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_cards, :hover_description, :text
  end
end

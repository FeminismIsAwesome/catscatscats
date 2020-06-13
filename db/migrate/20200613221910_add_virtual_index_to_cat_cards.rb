class AddVirtualIndexToCatCards < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_cards, :virtual_id, :integer
  end
end

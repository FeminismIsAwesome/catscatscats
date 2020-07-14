class AddTurnCountToCatPlayer < ActiveRecord::Migration[6.0]
  def change
    add_column :cat_players, :upkeeps_performed, :integer
  end
end

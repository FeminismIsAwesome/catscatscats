# == Schema Information
#
# Table name: cat_players
#
#  id          :bigint           not null, primary key
#  catnip      :integer          default(0)
#  food        :integer          default(0)
#  litterbox   :integer          default(0)
#  name        :string
#  toys        :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cat_game_id :bigint
#  remote_id   :string
#
# Indexes
#
#  index_cat_players_on_cat_game_id  (cat_game_id)
#
class CatPlayer < ApplicationRecord
  belongs_to :cat_game
end

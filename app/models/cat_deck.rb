# == Schema Information
#
# Table name: cat_decks
#
#  id           :bigint           not null, primary key
#  deck_pile    :jsonb
#  discard_pile :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  cat_game_id  :bigint
#
# Indexes
#
#  index_cat_decks_on_cat_game_id  (cat_game_id)
#
class CatDeck < ApplicationRecord
  belongs_to :cat_game
end

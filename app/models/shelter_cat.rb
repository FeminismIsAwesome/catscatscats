# == Schema Information
#
# Table name: shelter_cats
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cat_card_id :bigint
#  cat_game_id :bigint
#
# Indexes
#
#  index_shelter_cats_on_cat_card_id  (cat_card_id)
#  index_shelter_cats_on_cat_game_id  (cat_game_id)
#
class ShelterCat < ApplicationRecord
  belongs_to :cat_game
  belongs_to :cat_card

  has_many :shelter_cat_bids, dependent: :delete_all

  def biggest_player_bid
    highest_bid = shelter_cat_bids.map{|shelter_cat_bid| shelter_cat_bid.bid_amount}.max
    shelter_cat_bids.order(updated_at: :asc).find{|cat_bid| cat_bid.bid_amount == highest_bid}
  end

end

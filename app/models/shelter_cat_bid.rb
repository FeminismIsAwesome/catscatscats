# == Schema Information
#
# Table name: shelter_cat_bids
#
#  id             :bigint           not null, primary key
#  bid_amount     :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cat_player_id  :bigint
#  shelter_cat_id :bigint
#
# Indexes
#
#  index_shelter_cat_bids_on_cat_player_id   (cat_player_id)
#  index_shelter_cat_bids_on_shelter_cat_id  (shelter_cat_id)
#
class ShelterCatBid < ApplicationRecord
  belongs_to :cat_player
  belongs_to :shelter_cat
  def as_json
    (super).merge({cat_player_name: cat_player.name})
  end
end

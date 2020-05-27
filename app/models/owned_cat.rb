# == Schema Information
#
# Table name: owned_cats
#
#  id              :bigint           not null, primary key
#  happiness_level :integer          default(3)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cat_card_id     :bigint
#  cat_player_id   :bigint
#
# Indexes
#
#  index_owned_cats_on_cat_card_id    (cat_card_id)
#  index_owned_cats_on_cat_player_id  (cat_player_id)
#
class OwnedCat < ApplicationRecord
  belongs_to :cat_card
  belongs_to :cat_player

end

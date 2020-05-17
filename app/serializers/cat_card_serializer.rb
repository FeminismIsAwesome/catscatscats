# == Schema Information
#
# Table name: cat_cards
#
#  id          :bigint           not null, primary key
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  subtype     :string
#  description :string
#  number_tl   :string
#  number_tr   :string
#  kind        :string
#  self_hosted :boolean
#  tile_image  :text
#
class CatCardSerializer < ActiveModel::Serializer
  attributes :id, :title
end

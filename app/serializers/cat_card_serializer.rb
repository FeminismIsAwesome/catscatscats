# == Schema Information
#
# Table name: cat_cards
#
#  id                :bigint           not null, primary key
#  description       :string
#  hover_description :text
#  kind              :string
#  number_tl         :string
#  number_tr         :string
#  self_hosted       :boolean
#  subtype           :string
#  tile_image        :text
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  virtual_id        :integer
#
class CatCardSerializer < ActiveModel::Serializer
  attributes :id, :title
end

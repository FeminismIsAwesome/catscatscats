# == Schema Information
#
# Table name: cat_images
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CatImage < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize: "200x200"
  end

end

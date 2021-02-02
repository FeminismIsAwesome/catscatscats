# == Schema Information
#
# Table name: emails
#
#  id                  :bigint           not null, primary key
#  email               :string
#  ian_confirmed_legit :boolean
#  name                :string
#  notes               :text
#  playtester          :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Email < ApplicationRecord
  validates :email, presence: true
end

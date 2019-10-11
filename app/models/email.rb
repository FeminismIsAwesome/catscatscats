class Email < ApplicationRecord
  validates :email, presence: true
end
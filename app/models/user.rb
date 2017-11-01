class User < ApplicationRecord
  has_many :devices

  validates :uid, uniqueness: true
end

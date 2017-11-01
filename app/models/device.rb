class Device < ApplicationRecord
  belongs_to :user, optional: true

  validates :uid, :iid, uniqueness: true
  validates :title, presence: true
end

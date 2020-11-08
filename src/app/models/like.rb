class Like < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :micropost, optional: true
  has_many :notifications, dependent: :destroy
  validates :user, presence: true
  validates :micropost, presence: true
end

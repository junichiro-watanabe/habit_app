class Belong < ApplicationRecord
  has_one :achievement, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :group, optional: true
  has_many :notifications, dependent: :destroy
  validates :user, presence: true
  validates :group, presence: true
end

class Like < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :micropost, optional: true
  validates :user, presence: true
  validates :micropost, presence: true
end

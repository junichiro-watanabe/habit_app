class Micropost < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :user, optional: true
  belongs_to :history, optional: true
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 255 }

  def poster?(user)
    self.user == user
  end
end

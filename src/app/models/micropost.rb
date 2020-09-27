class Micropost < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :history, optional: true
  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 255}
end

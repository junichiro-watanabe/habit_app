class History < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :achievement, optional: true
  has_many :microposts, dependent: :destroy
  validates :achievement, presence: true
  validates :date, presence: true
end

class History < ApplicationRecord
  belongs_to :achievement, optional: true
  has_one :micropost, dependent: :destroy
  validates :achievement, presence: true
  validates :date, presence: true
end

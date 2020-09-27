class Achievement < ApplicationRecord
  belongs_to :belong, optional: true
  has_many :histories, dependent: :destroy
  validates :belong, presence: true
end

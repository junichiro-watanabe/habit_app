class Achievement < ApplicationRecord
  belongs_to :belong, optional: true
  validates :belong, presence: true
end

class Group < ApplicationRecord
  has_many :belongs, dependent: :destroy
  has_many :members, through: :belongs, source: :user
  has_many :achieved_list, through: :belongs, source: :belongs
  belongs_to :user
  has_one_attached :image
  validates :name, presence: true, length: {maximum: 50}
  validates :habit, presence: true, length: {maximum: 50}
  validates :overview, length: {maximum: 255}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "形式が無効です" },
                    size:         { less_than: 5.megabytes,
                                    message: "サイズが5MB超過です" }

  def profile_image
    image.variant(resize_to_limit: [150, 150])
  end

  def add_member(user)
    member << user
  end

  def member?(user)
    member.include?(user)
  end

  def owner?(user)
    self.user == user
  end
end

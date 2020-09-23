class User < ApplicationRecord
  has_many :belongs, dependent: :destroy
  has_many :belonging, through: :belongs, source: :group
  has_many :achieving, through: :belongs, source: :achievement
  has_many :groups, dependent: :destroy
  has_one_attached :image
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                                    format: {with: VALID_EMAIL_REGEX},
                                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 8}, allow_nil:true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "形式が無効です" },
                    size:         { less_than: 5.megabytes,
                                    message: "サイズが5MB超過です" }

    def profile_image
      image.variant(resize_to_limit: [150, 150])
    end

    def belong(group)
      belonging << group
      belongs.find_by(group: group).create_achievement
    end

    def belonging?(group)
      belonging.include?(group)
    end

    def leave(group)
      belongs.find_by(group: group).destroy
    end

    def achieved?(group)
      achieving.find_by(belong: self.belongs.find_by(group: group)).achieved if self.belonging?(group)
    end

    def toggle_achieved(group)
      self.achieving.find_by(belong: self.belongs.find_by(group: group)).toggle!(:achieved) if self.belonging?(group)
    end

end

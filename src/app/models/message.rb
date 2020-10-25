class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true
  validates :content, presence: true, length: { maximum: 255 }
end

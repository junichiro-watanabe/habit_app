class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :relationship, optional: true
  belongs_to :belong, optional: true
  belongs_to :like, optional: true
  belongs_to :message, optional: true
  belongs_to :visitor, class_name: "User", optional: true
  belongs_to :visited, class_name: "User", optional: true
  validates :visitor, presence: true
  validates :visited, presence: true
  validates :action, presence: true
end

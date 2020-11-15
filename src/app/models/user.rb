class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :belongs, dependent: :destroy
  has_many :belonging, through: :belongs, source: :group
  has_many :achieving, through: :belongs, source: :achievement
  has_many :groups, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_messages, class_name: "Message",
                             foreign_key: "sender_id",
                             dependent: :destroy
  has_many :receivers, through: :active_messages, source: :receiver
  has_many :passive_messages, class_name: "Message",
                              foreign_key: "receiver_id",
                              dependent: :destroy
  has_many :senders, through: :passive_messages, source: :sender
  has_many :likes, dependent: :destroy
  has_many :like_feeds, through: :likes, source: :micropost
  has_many :active_notifications, class_name: "Notification",
                                  foreign_key: "visitor_id",
                                  dependent: :destroy
  has_many :passive_notifications, class_name: "Notification",
                                   foreign_key: "visited_id",
                                   dependent: :destroy
  has_one_attached :image
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :introduction, length: { maximum: 255 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "形式が無効です" },
                    size: { less_than: 5.megabytes,
                            message: "サイズが5MB超過です" }

  def profile_image
    image.variant(resize_to_limit: [150, 150])
  end

  def belong(group)
    belonging << group
    belong = belongs.find_by(group: group)
    belong.create_achievement
    create_notification_belong(belong)
  end

  def belonging?(group)
    belonging.include?(group)
  end

  def leave(group)
    belongs.find_by(group: group).destroy
  end

  def achieved?(group)
    group.belongs.find_by(user: self).achievement.achieved if belonging?(group)
  end

  def not_achieved
    group_ids = []
    belongs.includes(:group).includes(achievement: :histories).each do |belong|
      if belong.achievement.histories.find_by(date: Date.today).nil?
        belong.achievement.update(achieved: false)
      else
        belong.achievement.update(achieved: true)
      end
      group_ids.push(belong.group.id) unless achieved?(belong.group)
    end
    groups = Group.where("id IN (?)", group_ids)
    array = []
    groups.each do |group|
      props = {
        group_id: group.id,
        group_image: (group.image.attached? ? rails_blob_path(group.image, only_path: true) : "/assets/default-#{group.class.name}.png"),
        group_name: group.name,
        group_path: group_path(group),
        group_habit: group.habit,
        achievement_path: achievement_path(group),
        owner_name: group.user.name,
        owner_path: user_path(group.user),
        member_path: member_group_path(group),
        member_count: group.members.count,
        belong: belonging?(group),
        achieved: achieved?(group)
      }
      array.push(props)
    end
    array
  end

  def toggle_achieved(group)
    achievement = group.belongs.find_by(user: self).achievement
    if achieved?(group)
      history = History.find_by(achievement: achievement, date: Date.today)
      history&.destroy
    else
      if achievement.histories.find_by(date: Date.today).nil?
        history = achievement.histories.create(date: Date.today)
        history.microposts.create(user: self, content: "#{history.date} 分の <a href=\"/groups/#{group.id}\">#{group.name}</a> の目標を達成しました。\n目標：#{group.habit}")
      end
    end
    achievement.toggle!(:achieved) if belonging?(group)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id"
    group_ids = "SELECT group_id FROM belongs
                   WHERE user_id = :user_id"
    group_members_ids = "SELECT user_id FROM belongs
                           WHERE group_id IN (#{group_ids})"
    belong_ids = "SELECT id FROM belongs
                    WHERE user_id IN (#{following_ids})
                    OR user_id IN (#{group_members_ids})
                    AND group_id IN (#{group_ids})"
    achievement_ids = "SELECT id FROM achievements
                         WHERE belong_id IN (#{belong_ids})"
    history_ids = "SELECT id FROM histories
                     WHERE achievement_id IN (#{achievement_ids})"
    Micropost.where("history_id IN (#{history_ids})",
                    user_id: id, today: Date.today)
  end

  def encouraged
    following_ids = "SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id"
    group_ids = "SELECT group_id FROM belongs
                   WHERE user_id = :user_id"
    group_members_ids = "SELECT user_id FROM belongs
                           WHERE group_id IN (#{group_ids})
                           AND user_id != :user_id"
    belong_ids = "SELECT id FROM belongs
                    WHERE user_id IN (#{following_ids})
                    OR user_id IN (#{group_members_ids})
                    AND group_id IN (#{group_ids})"
    achievement_ids = "SELECT id FROM achievements
                         WHERE belong_id IN (#{belong_ids})"
    history_ids = "SELECT id FROM histories
                     WHERE achievement_id IN (#{achievement_ids})
                     AND date = :today"
    microposts = Micropost.where("history_id IN (#{history_ids})
                                    AND encouragement = true",
                                 user_id: id, today: Date.today)
    array = []
    microposts.includes(:user) \
              .includes(history: { achievement: { belong: :group } }) \
              .each do |micropost|
      user = micropost.user
      group = micropost.history.achievement.belong.group
      history = micropost.history
      next if user.nil? || group.nil? || history.nil?

      props = {
        user_image: (user.image.attached? ? rails_blob_path(user.image, only_path: true) : "/assets/default-#{user.class.name}.png"),
        user_name: user.name,
        user_path: user_path(user),
        group_name: group.name,
        group_path: group_path(group),
        content: micropost.content,
        time: micropost.created_at.strftime("%Y-%m-%d %H:%M"),
        history: history,
        encouragement: micropost.encouragement,
        like_path: like_path(micropost),
        like: like?(micropost),
        like_count: micropost.likers.count
      }
      array.push(props)
    end
    array
  end

  def follow(other_user)
    following << other_user
    relationship = active_relationships.find_by(followed: other_user)
    create_notification_follow(relationship)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed: other_user).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def last_message(user)
    message_ids = "SELECT id FROM messages
                     where sender_id = :current_user_id AND receiver_id = :user_id
                     OR sender_id = :user_id AND receiver_id = :current_user_id"
    Message.where("id IN (#{message_ids})",
                  current_user_id: id, user_id: user.id).order("created_at DESC").limit(1)
  end

  def like(feed)
    like_feeds << feed
    like = likes.find_by(micropost: feed)
    create_notification_like(like)
  end

  def unlike(feed)
    likes.find_by(micropost: feed).destroy
  end

  def like?(feed)
    like_feeds.include?(feed)
  end

  def achievement_history
    belong_ids = "SELECT id FROM belongs
                    WHERE user_id = :user_id"
    achievement_ids = "SELECT id FROM achievements
                         WHERE belong_id IN (#{belong_ids})"
    histories = History.where("achievement_id IN (#{achievement_ids})", user_id: id)
    hash = {}
    histories.includes(:microposts) \
             .includes(achievement: { belong: :group }) \
             .each do |history|
      micropost = history.microposts.last
      group = history.achievement.belong.group
      next if micropost.nil? || group.nil? || micropost.encouragement

      props = {
        user_image: (image.attached? ? rails_blob_path(image, only_path: true) : "/assets/default-#{self.class.name}.png"),
        user_name: name,
        user_path: user_path(self),
        group_name: group.name,
        group_path: group_path(group),
        content: micropost.content,
        time: micropost.created_at.strftime("%Y-%m-%d %H:%M"),
        history: history,
        encouragement: micropost.encouragement,
        like_path: like_path(micropost),
        like_count: micropost.likers.count
      }
      if hash.key?(history.date)
        hash[history.date].push(props)
      else
        hash[history.date] = [props]
      end
    end
    hash
  end

  def create_notification_follow(relationship)
    unless self == relationship.followed
      active_notifications.create(visitor: self,
                                  visited: relationship.followed,
                                  relationship: relationship,
                                  action: "follow")
    end
  end

  def create_notification_belong(belong)
    unless self == belong.group.user
      active_notifications.create(visitor: self,
                                  visited: belong.group.user,
                                  belong: belong,
                                  action: "belong")
    end
  end

  def create_notification_like(like)
    unless self == like.micropost.user
      active_notifications.create(visitor: self,
                                  visited: like.micropost.user,
                                  like: like,
                                  action: "like")
    end
  end

  def create_notification_message(message)
    unless self == message.receiver
      active_notifications.create(visitor: self,
                                  visited: message.receiver,
                                  message: message,
                                  action: "message")
    end
  end

  def notification
    hash = { count: passive_notifications.where(checked: false).count,
             information: [] }
    passive_notifications.includes(:visitor) \
                         .includes(:visited) \
                         .includes(like: { micropost: { history: { achievement: { belong: :group } } } }) \
                         .includes(like: { micropost: :user }) \
                         .includes(belong: :group) \
                         .includes(:message) \
                         .each do |notification|
      information = if !notification.relationship.nil?
                      {}
                    elsif !notification.belong.nil?
                      { group: notification.belong.group.name, group_path: group_path(notification.belong.group) }
                    elsif !notification.like.nil?
                      { user_image: (image.attached? ? rails_blob_path(image, only_path: true) : "/assets/default-#{self.class.name}.png"),
                        user_name: name,
                        user_path: user_path(self),
                        group_name: notification.like.micropost.history.achievement.belong.group.name,
                        group_path: group_path(notification.like.micropost.history.achievement.belong.group),
                        content: notification.like.micropost.content,
                        time: notification.like.micropost.created_at.strftime("%Y-%m-%d %H:%M"),
                        history: notification.like.micropost.history,
                        encouragement: notification.like.micropost.encouragement,
                        like_path: like_path(notification.like.micropost),
                        like_count: notification.like.micropost.likers.count,
                        poster: notification.like.micropost.poster?(self) || admin?,
                        micropost_path: micropost_path(notification.like.micropost) }
                    elsif !notification.message.nil?
                      { message_path: message_path(notification.visitor) }
                    end
      information.merge!({ visitor: notification.visitor.name,
                           visitor_path: user_path(notification.visitor),
                           visited: notification.visited.name,
                           action: notification.action,
                           checked: notification.checked,
                           time: notification.created_at.strftime("%Y-%m-%d %H:%M") })
      hash[:information].push(information)
    end
    hash
  end
end

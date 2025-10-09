class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :userchats
  has_many :chats, through: :userchats

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  validates :username, uniqueness: true, format: { with: /\A[\w_]+\z/, message: "can only contain letters, numbers and underscores" }, length: { maximum: 20 }

  def friends
    return [] unless self.persisted?
    friend_ids = Message
                  .where("receiver_id = ? OR sender_id = ?", self.id, self.id)
                  .pluck(:sender_id, :receiver_id)
                  .flatten
                  .uniq - [ self.id ]
    User.where(id: friend_ids)
  end
end

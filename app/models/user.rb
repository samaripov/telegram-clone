class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :userchats
  has_many :chats, through: :userchats

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  validates :username, uniqueness: true, format: { with: /\A[\w_]+\z/, message: "can only contain letters, numbers and underscores" }, length: { maximum: 20 }

  def open_chats
    return [] unless self.persisted?
    chat_ids = Userchat
      .where(user_id: self.id)
      .pluck(:chat_id)
    Chat.where(id: chat_ids)
  end
end

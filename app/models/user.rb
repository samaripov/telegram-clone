class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  validates :username, uniqueness: true, format: { with: /\A[\w_]+\z/, message: "can only contain letter, numbers and underscores" }, length: { maximum: 20 }
end

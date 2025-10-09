class Userchat < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :chat, class_name: "Chat", foreign_key: "chat_id"
end

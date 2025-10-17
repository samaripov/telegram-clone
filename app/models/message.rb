class Message < ApplicationRecord
  has_many_attached :images
  belongs_to :receiver, class_name: "Chat", foreign_key: "receiver_id"
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  validates :text, length: { minimum: 1 }
end

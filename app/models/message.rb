class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  validates :text, length: { minimum: 1 }

  def chat_id
    user_ids = [ sender_id, receiver_id ]
    "#{user_ids.min}_#{user_ids.max}"
  end

  broadcasts_to ->(message) { [ message.chat_id, "messages" ] }, inserts_by: :append
end

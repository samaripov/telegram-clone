class Chat < ApplicationRecord
  has_many :messages, foreign_key: "receiver_id"
  has_many :userchats
  has_many :users, through: :userchats

  def label(current_user)
    return nil unless self.persisted?
    users_in_chat = self.users - [ current_user ]

    if users_in_chat.length == 1
      users_in_chat[0].username
    else
      self.name
    end
  end
end

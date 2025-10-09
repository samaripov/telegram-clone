class Chat < ApplicationRecord
  has_many :userchats
  has_many :users, through: :userchats
  has_many :messages

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

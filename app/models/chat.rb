class Chat < ApplicationRecord
  has_many :userchats
  has_many :users, through: :userchats
  has_many :messages

  
end

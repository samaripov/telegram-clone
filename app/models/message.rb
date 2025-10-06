class Message < ApplicationRecord
  # belongs_to :sender, class_name: "User"
  # belongs_to :receiver, class_name: "User"
  validates :text, length: { minimum: 1 }
  broadcasts_to ->(message) { [ "messages" ] }, inserts_by: :append
end

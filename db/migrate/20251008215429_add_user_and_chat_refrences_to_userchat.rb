class AddUserAndChatRefrencesToUserchat < ActiveRecord::Migration[8.0]
  def change
    add_reference :userchats, :user, null: false, foreign_key: { to_table: :users }
    add_reference :userchats, :chat, null: false, foreign_key: { to_table: :chats }
  end
end

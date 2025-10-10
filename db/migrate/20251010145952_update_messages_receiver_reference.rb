class UpdateMessagesReceiverReference < ActiveRecord::Migration[8.0]
  def change
    remove_reference :messages, :receiver
    add_reference :messages, :receiver, null: false, foreign_key: { to_table: :chats }
  end
end

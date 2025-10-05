class ChangeNullConstraintsOnSenderAndReceiverInMessages < ActiveRecord::Migration[8.0]
  def change
    change_column_null :messages, :sender_id, true
    change_column_null :messages, :receiver_id, true
  end
end

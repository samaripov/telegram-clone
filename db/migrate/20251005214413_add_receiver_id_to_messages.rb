class AddReceiverIdToMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :messages, :receiver, null: false, foreign_key: { to_table: :users }
  end
end

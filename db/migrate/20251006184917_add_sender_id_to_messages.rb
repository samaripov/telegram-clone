class AddSenderIdToMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :messages, :sender, null: false, foreign_key: { to_table: :users }
  end
end

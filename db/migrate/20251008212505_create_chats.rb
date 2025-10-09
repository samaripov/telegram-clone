class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.text :name

      t.timestamps
    end
  end
end

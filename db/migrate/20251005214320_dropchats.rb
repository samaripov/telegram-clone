class Dropchats < ActiveRecord::Migration[8.0]
  def change
    drop_table :chats
  end
end

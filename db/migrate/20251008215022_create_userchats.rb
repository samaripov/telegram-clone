class CreateUserchats < ActiveRecord::Migration[8.0]
  def change
    create_table :userchats do |t|
      t.timestamps
    end
  end
end

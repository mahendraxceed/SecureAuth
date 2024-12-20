class AddMobileNoIndexToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :mobile_no, unique: true
  end
end

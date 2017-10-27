class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :token
      t.integer :user_id
      t.boolean :is_returned, default: true

      t.timestamps
    end
  end
end

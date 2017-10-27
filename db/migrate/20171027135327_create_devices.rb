class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :token
      t.user_id :integer
      is_returned :boolean

      t.timestamps
    end
  end
end

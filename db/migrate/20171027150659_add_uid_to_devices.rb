class AddUidToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :uid, :integer
  end
end

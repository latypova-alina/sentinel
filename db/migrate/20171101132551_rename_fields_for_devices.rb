class RenameFieldsForDevices < ActiveRecord::Migration[5.1]
  def change
    rename_column :devices, :token, :apn_token
    add_column :devices, :iid, :string
  end
end

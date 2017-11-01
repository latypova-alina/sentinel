class RenameNameIntoTitleForDevices < ActiveRecord::Migration[5.1]
  def change
    rename_column :devices, :name, :title
  end
end

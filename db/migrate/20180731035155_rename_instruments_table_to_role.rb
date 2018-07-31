class RenameInstrumentsTableToRole < ActiveRecord::Migration[5.2]
  def change
    rename_table :instruments, :roles
    rename_table :user_instruments, :user_roles
    rename_column :user_roles, :instrument_id, :role_id
  end
end

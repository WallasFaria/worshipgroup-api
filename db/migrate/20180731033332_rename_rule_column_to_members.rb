class RenameRuleColumnToMembers < ActiveRecord::Migration[5.2]
  def change
    rename_column :members, :rule, :permission
  end
end

class CreatePresentationsMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :presentations_members do |t|
      t.references :member, foreign_key: true
      t.references :presentation, foreign_key: true

      t.timestamps
    end
  end
end

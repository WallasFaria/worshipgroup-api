class CreatePresentations < ActiveRecord::Migration[5.2]
  def change
    create_table :presentations do |t|
      t.datetime :date
      t.string :description
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end

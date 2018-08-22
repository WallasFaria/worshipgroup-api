class CreateRehearsals < ActiveRecord::Migration[5.2]
  def change
    create_table :rehearsals do |t|
      t.string :date
      t.references :presentation, foreign_key: true

      t.timestamps
    end
  end
end

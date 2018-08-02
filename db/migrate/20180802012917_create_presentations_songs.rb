class CreatePresentationsSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :presentations_songs do |t|
      t.string :tone
      t.references :song, foreign_key: true
      t.references :presentation, foreign_key: true

      t.timestamps
    end
  end
end

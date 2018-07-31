class RenameMusicsTableToSongs < ActiveRecord::Migration[5.2]
  def change
    rename_table :musics, :songs
  end
end

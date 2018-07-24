class AddGroupToMusics < ActiveRecord::Migration[5.2]
  def change
    add_reference :musics, :group, foreign_key: true
  end
end

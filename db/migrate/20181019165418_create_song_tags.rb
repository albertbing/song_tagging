class CreateSongTags < ActiveRecord::Migration[5.1]
  def change
    create_table :song_tags do |t|
      t.references :song, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end

class CreateSongsTags < ActiveRecord::Migration[5.0]

  def change
    create_table :songs_tags do |t|
      t.integer :tag_id
      t.integer :song_id

      t.timestamps
    end
  end
  
end

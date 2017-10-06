class CreateGenreEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :genre_events do |t|
      t.string :title

      t.timestamps
    end
  end
end

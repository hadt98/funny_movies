class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string 'title'
      t.string owner
      t.string 'description'
      t.string 'source'
      t.string 'link'
      t.timestamps
    end
  end
end

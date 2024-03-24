class CreateVideoIcons < ActiveRecord::Migration[7.1]
  def change
    create_table :video_icons do |t|
      t.references :video
      t.string 'code'
      t.references :user
      t.timestamps
    end
  end
end

class CreateVideoIcons < ActiveRecord::Migration[7.1]
  def change
    create_table :video_icons do |t|
      t.numeric 'video_id'
      t.string 'icon_code'
      t.string 'count'
      t.timestamps
    end
  end
end

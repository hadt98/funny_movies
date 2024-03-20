class CreateIcons < ActiveRecord::Migration[7.1]
  def change
    create_table :icons do |t|
      t.string 'name'
      t.string 'code'
      t.string 'symbol'
      t.timestamps
    end
  end
end

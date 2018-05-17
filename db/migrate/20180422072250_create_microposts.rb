class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.string :denimname
      t.string :brandname
      t.string :type
      t.string :color
      t.string :image
      t.references :user, foreign_key: true
      t.text :comment
      

      t.timestamps
    end
    add_index :microposts,[:user_id,:created_at]
  end
end

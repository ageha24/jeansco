class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :gender
      t.string :profileimage
      t.text :introduce

      t.timestamps
    end
  end
end

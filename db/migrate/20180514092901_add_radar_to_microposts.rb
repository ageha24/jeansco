class AddRadarToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :popular, :integer
    add_column :microposts, :fit, :integer
    add_column :microposts, :price, :integer
    add_column :microposts, :design, :integer
  end
end

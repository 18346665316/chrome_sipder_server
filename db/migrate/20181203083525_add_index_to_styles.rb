class AddIndexToStyles < ActiveRecord::Migration[5.2]
  def change
    add_column :styles, :stylenum, :string
    add_column :styles, :stylename, :string
    add_column :styles, :imgurl, :string
    add_column :styles, :discount_price, :string
  end
end

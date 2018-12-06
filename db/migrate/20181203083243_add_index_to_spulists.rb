class AddIndexToSpulists < ActiveRecord::Migration[5.2]
  def change
    add_column :spulists, :spuid, :string
    add_column :spulists, :title, :string
    add_column :spulists, :price, :string
    add_column :spulists, :discount_price, :string
    add_column :spulists, :url, :string
  end
end

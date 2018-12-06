class AddIndexToSkulists < ActiveRecord::Migration[5.2]
  def change
    add_column :skulists, :skuid, :string
    add_column :skulists, :spuid, :string
    add_column :skulists, :size, :string
    add_column :skulists, :style, :string
    add_column :skulists, :price, :string
    add_column :skulists, :stock, :string
  end
end

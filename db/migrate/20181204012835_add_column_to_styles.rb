class AddColumnToStyles < ActiveRecord::Migration[5.2]
  def change
    add_column :styles, :isonsale, :string
  end
end

class AddIndexToSizes < ActiveRecord::Migration[5.2]
  def change
    add_column :sizes, :sizenum, :string
    add_column :sizes, :sizename, :string
  end
end

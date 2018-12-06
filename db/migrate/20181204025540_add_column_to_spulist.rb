class AddColumnToSpulist < ActiveRecord::Migration[5.2]
  def change
    add_column :spulists, :details, :text
  end
end

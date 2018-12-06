class CreateSpulists < ActiveRecord::Migration[5.2]
  def change
    create_table :spulists do |t|

      t.timestamps
    end
  end
end

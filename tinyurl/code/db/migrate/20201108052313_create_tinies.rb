class CreateTinies < ActiveRecord::Migration[5.0]
  def change
    create_table :tinies do |t|

      t.timestamps
    end
  end
end

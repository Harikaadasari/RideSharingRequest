class CreateDrivers < ActiveRecord::Migration[6.0]
  def change
    create_table :drivers do |t|
      t.string :name
      t.float :location_x
      t.float :location_y
      t.boolean :available

      t.timestamps
    end
  end
end

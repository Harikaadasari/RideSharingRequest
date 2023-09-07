class CreateRiders < ActiveRecord::Migration[6.0]
  def change
    create_table :riders do |t|
      t.string :name
      t.float :location_x
      t.float :location_y

      t.timestamps
    end
  end
end

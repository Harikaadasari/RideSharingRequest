class CreateRideDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :ride_details do |t|
      t.integer :ride_request_id
      t.float :distance
      t.float :fare

      t.timestamps
    end
  end
end

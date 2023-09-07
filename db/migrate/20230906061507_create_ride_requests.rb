class CreateRideRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :ride_requests do |t|
      t.integer :rider_id
      t.integer :driver_id
      t.datetime :requested_at
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end

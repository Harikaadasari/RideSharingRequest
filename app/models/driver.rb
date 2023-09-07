class Driver < ApplicationRecord
	has_many :ride_requests
	validates :name, presence: true
	validates :location_x, presence: true
	validates :location_y, presence: true
end

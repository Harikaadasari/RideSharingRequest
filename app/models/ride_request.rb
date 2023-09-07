class RideRequest < ApplicationRecord
  belongs_to :rider
  belongs_to :driver
  has_one :ride_detail
end

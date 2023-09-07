class RideRequestsController < ApplicationController
  # Other actions...

  # Create a new ride request
  # skip_before_action :verify_authenticity_token, only: [:create]
  protect_from_forgery with: :null_session 
  def create
    ride_request = RideRequest.new(ride_request_params)

    if ride_request.save
      render json: ride_request, status: :created
    else
      render json: ride_request.errors, status: :unprocessable_entity
    end
  end

  # Retrieve a list of ride requests
  def index
    ride_requests = RideRequest.all
    render json: ride_requests
  end

  # Retrieve a specific ride request by ID
  def show
    ride_request = RideRequest.find_by(id: params[:id])

    if ride_request
      render json: ride_request
    else
      render json: { message: 'Ride request not found' }, status: :not_found
    end
  end

  # Match a rider with a driver
  
  

  # Match a rider with a driver
def match
  rider = Rider.find_by(id: params[:rider_id])

  if rider
    driver = Driver.where(available: true).order('RANDOM()').first

    if driver
      # Create a new ride request with the rider and driver
      ride_request = RideRequest.create(rider: rider, driver: driver, requested_at: Time.now)

      # Update driver availability to false
      driver.update(available: false)

      render json: {
        message: 'Ride request matched successfully',
        ride_request_id: ride_request.id,
        rider: rider,
        driver: driver
      }
    else
      render json: { message: 'No available drivers at the moment' }, status: :unprocessable_entity
    end
  else
    render json: { message: 'Rider not found' }, status: :not_found
  end
end

  def start_ride
    ride_request = RideRequest.find(params[:id])

    if ride_request
      # Ensure the driver is not available when the ride starts
      driver = ride_request.driver
      driver.update(available: false) if driver.available?

      ride_request.update(started_at: Time.now)
      render json: ride_request, include: [:rider, :driver], status: :ok
    else
      render json: { message: 'Ride not found' }, status: :not_found
    end
  end



  

   
  
  def calculate_distance
    ride_request = RideRequest.find(params[:id])
    rider = ride_request.rider
    driver = ride_request.driver

    if rider && driver && rider.location_x.present? && rider.location_y.present? && driver.location_x.present? && driver.location_y.present?
      distance = calculate_distance_between_rider_and_driver(rider, driver)
      render json: { distance: distance }
    else
      render json: { message: 'Invalid rider or driver location data' }, status: :unprocessable_entity
    end
  end


  # Calculate ride details and fare
  def calculate_ride_details
    ride_request = RideRequest.find(params[:id])
    rider = ride_request.rider
    driver = ride_request.driver

    distance = calculate_distance_between_rider_and_driver(rider, driver)
    fare = calculate_fare(distance)

    ride_detail = RideDetail.create(ride_request: ride_request, distance: distance, fare: fare)
    render json: { ride_detail: ride_detail }
  end

  # Complete a ride
  def complete_ride
    ride_request = RideRequest.find(params[:id])

    if ride_request
      ride_request.update(completed_at: Time.now)
      render json: ride_request, include: [:rider, :driver], status: :ok
    else
      render json: { message: 'Ride not found' }, status: :not_found
    end
  end


  private

  # Define strong parameters for ride request creation
  def ride_request_params
    params.require(:ride_request).permit(:rider_id, :driver_id)
  end

  def calculate_distance_between_rider_and_driver(rider, driver)
    return 0 if rider.nil? || driver.nil?

    Math.sqrt((rider.location_x - driver.location_x)**2 + (rider.location_y - driver.location_y)**2).round(2)
  end

  def calculate_fare(distance)
    (distance * FARE_PER_KM).round(2)
  end

  FARE_PER_KM = 1.5 # Adjust the fare rate as needed
end

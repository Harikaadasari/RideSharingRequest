# app/controllers/riders_controller.rb
class RidersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
  before_action :set_rider, only: [:show, :update, :destroy]

  def index
    @riders = Rider.all
    render json: @riders
  end

  def show
    render json: @rider
  end

  def create
    @rider = Rider.new(rider_params)

    if @rider.save
      render json: @rider, status: :created
    else
      render json: @rider.errors, status: :unprocessable_entity
    end
  end

  def update
    if @rider.update(rider_params)
      render json: @rider
    else
      render json: @rider.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @rider.destroy
  end

  private

  def set_rider
    @rider = Rider.find(params[:id])
  end

  def rider_params
    # Update the permit to accept location_x and location_y separately
    params.require(:rider).permit(:name, :location_x, :location_y)
  end
end

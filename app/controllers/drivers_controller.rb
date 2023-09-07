# app/controllers/drivers_controller.rb
class DriversController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
  before_action :set_driver, only: [:show, :update, :destroy]

  def index
    @drivers = Driver.all
    render json: @drivers
  end

  def show
    render json: @driver
  end

  def create
    @driver = Driver.new(driver_params)

    if @driver.save
      render json: @driver, status: :created
    else
      render json: @driver.errors, status: :unprocessable_entity
    end
  end

  def update
    if @driver.update(driver_params)
      render json: @driver
    else
      render json: @driver.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @driver.destroy
  end

  private

  def set_driver
    @driver = Driver.find(params[:id])
  end

  def driver_params
    # Update the permit to accept location_x and location_y separately
    params.require(:driver).permit(:name, :location_x, :location_y)
  end
end

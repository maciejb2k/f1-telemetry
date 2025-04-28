class CarsController < ActionController::API
  before_action :set_car, only: [:show, :update, :destroy]

  # GET /cars
  def index
    cars = Car.all
    render json: cars
  end

  # GET /cars/:code
  def show
    render json: @car
  end

  # POST /cars
  def create
    car = Car.new(car_params)
    if car.save
      render json: car, status: :created
    else
      render json: car.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cars/:id
  def update
    if @car.update(car_params)
      render json: @car
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cars/:id
  def destroy
    @car.destroy
    head :no_content
  end

  private

    def set_car
      @car = Car.find_by!(car_code: params[:code])
    end

    def car_params
      params.require(:car).permit(:car_code, :driver, :chassis, :team_name, :driver_photo_url)
    end
end

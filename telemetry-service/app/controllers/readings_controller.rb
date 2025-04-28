class ReadingsController < ActionController::API
  before_action :set_car
  before_action :set_reading, only: [:show, :update, :destroy]

  # GET /cars/:car_code/readings
  def index
    readings = @car.readings.order(created_at: :desc)
    render json: readings
  end

  # GET /cars/:car_code/readings/:id
  def show
    render json: @reading
  end

  # POST /cars/:car_code/readings
  def create
    readings_data = readings_params

    readings = readings_data.map do |reading_data|
      @car.readings.new(reading_data)
    end

    Reading.import!(readings)

    readings.each do |reading|
      publish_reading_event(@car.car_code, reading)
    end

    render json: { ids: readings.map(&:id) }, status: :created
  end

  # PATCH/PUT /cars/:car_code/readings/:id
  def update
    if @reading.update(single_reading_params)
      render json: @reading
    else
      render json: @reading.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cars/:car_code/readings/:id
  def destroy
    @reading.destroy
    head :no_content
  end

  # GET /cars/:car_code/readings/latest
  def latest
    readings = Reading
      .where(car: @car)
      .select('DISTINCT ON (metric) metric, value, created_at')
      .order('metric, created_at DESC')

    render json: {
      car_code: params[:car_code],
      timestamp: Time.current,
      readings: readings.map { |r| { metric: r.metric, value: r.value, updated_at: r.created_at } }
    }
  end

  private

    def set_car
      @car = Car.find_by!(car_code: params[:car_code])
    end

    def set_reading
      @reading = @car.readings.find(params[:id])
    end

    def readings_params
      params.require(:readings).map { |r| r.permit(:metric, :value, :session) }
    end

    def single_reading_params
      params.require(:reading).permit(:metric, :value, :session)
    end

    def publish_reading_event(car_code, reading)
      payload = {
        id: reading.id,
        car_code: car_code,
        metric: reading.metric,
        value: reading.value
      }

      routing_key = "reading.#{car_code}"
      RabbitmqPublisher.instance.publish(routing_key: routing_key, payload: payload)
    end
end

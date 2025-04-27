# app/controllers/readings_controller.rb
class ReadingsController < ActionController::API
  before_action :set_car

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

  private

  def set_car
    @car = Car.find_by!(car_code: params[:car_code])
  end

  def readings_params
    params.require(:readings).map { |r| r.permit(:metric, :value) }
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

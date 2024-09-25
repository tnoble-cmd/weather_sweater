class RoadTrip

  attr_reader :start_city, :end_city, :travel_time, :seconds, :arrival_time_date, :arrival_time_hour

  def initialize(directions, origin, destination)
    @start_city = origin
    @end_city = destination
    @travel_time = directions[:formattedTime]
    @seconds = directions[:time].to_i
    @arrival_time_date = arrival_time_calculator(@seconds).to_date.strftime('%Y-%m-%d')
    @arrival_time_hour = arrival_time_calculator(@seconds).hour.to_s
  end

  def arrival_time_calculator(time)
    current_time = Time.now
    arrival_time = current_time + time
    arrival_time
  end
end
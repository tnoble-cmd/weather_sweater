class RoadTripFacade
  def self.get_road_trip(origin, destination)
    directions_data = MapQuestService.get_directions(origin, destination)

    if directions_data[:routeError]
      { error: 'Impossible route' }
    else
      data = RoadTrip.new(directions_data, origin, destination)
    end

    weather_data = WeatherService.get_forecast(data.arrival_time_date, destination)
  end
end




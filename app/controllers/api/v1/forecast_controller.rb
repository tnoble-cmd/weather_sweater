class Api::V1::ForecastController < ApplicationController
  def show
    coordinates = MapQuestService.get_coordinates(params[:location])
    
    weather_data = WeatherService.get_weather(coordinates[:lat], coordinates[:lng])
    render json: ForecastSerializer.new(weather_data)
  end
end
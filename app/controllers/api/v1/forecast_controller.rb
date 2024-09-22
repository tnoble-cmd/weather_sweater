class Api::V1::ForecastController < ApplicationController
  def show
    coordinates = MapQuestService.new(params[:location]).get_coordinates
    
    weather_data = WeatherService.new(coordinates[:lat], coordinates[:lng]).get_weather
    render json: ForecastSerializer.new(weather_data).serializable_hash.to_json
  end
end
class Api::V1::BookSearchController < ApplicationController
  def index
    location = params[:location]
    quantity = params[:quantity].to_i #to check condition

    #check if the quantity is less than or equal to 0
    if quantity <= 0
      render json: { error: 'Quantity must be greater than 0' }, status: 400
      return
    end

    # i need encapsulation :( i was running out of time. wish i can refactor.
    coordinates = MapQuestService.new(location).get_coordinates
    weather_data = WeatherService.new(coordinates[:lat], coordinates[:lng]).get_weather

    forecast = {
      summary: weather_data[:current][:condition][:text],
      temperature: "#{weather_data[:current][:temp_f]} F"
    }

    book_service = BookService.new(location, quantity)
    books_data = book_service.formatted_books

    response_data = books_data.merge(forecast: forecast, destination: location)

    render json: BookSerializer.new(response_data).serializable_hash.to_json
  end
end
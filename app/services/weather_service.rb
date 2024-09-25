class WeatherService
  # def initialize(lat, lon)
  #   @lat = lat
  #   @lon = lon
  # end

  def self.get_weather(lat, lon)
    conn = Faraday.new(url: 'http://api.weatherapi.com')

    response = conn.get('/v1/forecast.json') do |req|
      req.params['key'] = Rails.application.credentials.weather_api[:key]
      req.params['q'] = "#{lat},#{lon}"
      req.params['days'] = 5
      req.params['aqi'] = 'no'
      req.params['alerts'] = 'no'
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  #im going to consume this api endpoint with destination and dt (date) params from RT poro. 
  #then i will pull the 24 hr forecast (based on @arrival_time_date) from the response and iterate it to find the @arrival_time_hour forecast

  # def self.get_forecast(arrival_time_date, destination)
  #   conn = Faraday.new(url: 'http://api.weatherapi.com')

  #   response = conn.get('/v1/forecast.json') do |req|
  #     req.params['key'] = Rails.application.credentials.weather_api[:key]
  #     req.params['q'] = destination
  #     req.params['dt'] = 5
  #     req.params['aqi'] = 'no'
  #     req.params['alerts'] = 'no'
  #   end
  #   JSON.parse(response.body, symbolize_names: true)
  # end
end
class WeatherService
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def get_weather
    conn = Faraday.new(url: 'http://api.weatherapi.com')

    response = conn.get('/v1/forecast.json') do |req|
      req.params['key'] = Rails.application.credentials.weather_api[:key]
      req.params['q'] = "#{@lat},#{@lon}"
      req.params['days'] = 5
      req.params['aqi'] = 'no'
      req.params['alerts'] = 'no'
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
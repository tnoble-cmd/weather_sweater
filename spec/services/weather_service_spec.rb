require 'rails_helper'

RSpec.describe WeatherService do
  before :each do
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?aqi=no&alerts=no&days=5&key=#{Rails.application.credentials.weather_api[:key]}&q=39.738453,-104.984853").
      to_return(status: 200, body: File.read('spec/fixtures/weather_response.json'), headers: {'Content-Type' => 'application/json'})
  end

  describe 'GET /v1/forecast.json' do
    it 'returns the weather for a given location' do
      weather_data = WeatherService.get_weather(39.738453, -104.984853) #from Denver mapquest response
      

      #structured right
      expect(weather_data).to be_a Hash

      #based on the response for the forecastserializer, i need to access all of these
      expect(weather_data).to have_key(:location)
      expect(weather_data).to have_key(:current)
      expect(weather_data).to have_key(:forecast)
      expect(weather_data[:forecast]).to have_key(:forecastday) 
      
      #all of these are hashes which is good
      expect(weather_data[:location]).to be_a Hash
      expect(weather_data[:current]).to be_a Hash
      expect(weather_data[:forecast]).to be_a Hash
      expect(weather_data[:forecast][:forecastday]).to be_an Array
      
      #5 days of forecast
      expect(weather_data[:forecast][:forecastday].count).to eq(5) 

      #will need this for the serializer , an hourly weather array of current day
      weather_data[:forecast][:forecastday].each do |day|
        expect(day[:hour]).to be_an Array
        expect(day[:hour].count).to eq(24)
      end
      
    end
  end
end
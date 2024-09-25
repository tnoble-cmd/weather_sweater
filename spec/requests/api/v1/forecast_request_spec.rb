require 'rails_helper'

RSpec.describe Api::V1::ForecastController, type: :controller do
  before :each do
    coordinates = JSON.parse(File.read('spec/fixtures/map_quest_response.json'), symbolize_names: true)
    allow(MapQuestService).to receive(:get_coordinates).and_return(coordinates)

    forecast_data = JSON.parse(File.read('spec/fixtures/weather_response.json'), symbolize_names: true)
    allow(WeatherService).to receive(:get_weather).and_return(forecast_data)
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { location: 'Denver,CO' }
      expect(response).to be_successful
    end

    it 'returns the correct forecast data' do
      get :show, params: { location: 'Denver,CO' }
      json_response = JSON.parse(response.body, symbolize_names: true)

      # Check structure
      expect(json_response).to be_a Hash
      expect(json_response).to have_key(:data)
      expect(json_response[:data]).to have_key(:id)
      expect(json_response[:data][:id]).to eq(nil)

      expect(json_response[:data]).to have_key(:type)
      expect(json_response[:data][:type]).to eq('forecast')
      

      #check attributes
      expect(json_response[:data]).to have_key(:attributes)
      attributes = json_response[:data][:attributes]
      expect(attributes).to have_key(:current_weather)
      expect(attributes).to have_key(:daily_weather)
      expect(attributes).to have_key(:hourly_weather)

      # Check current weather attributes
      current_weather = attributes[:current_weather]
      expect(current_weather).to have_key(:temperature)
      expect(current_weather).to have_key(:feels_like)
      expect(current_weather).to have_key(:humidity)
      expect(current_weather).to have_key(:uvi)
      expect(current_weather).to have_key(:visibility)
      expect(current_weather).to have_key(:condition)
      expect(current_weather).to have_key(:icon)

      # Check daily weather attributes for each element in the array (days)
      attributes[:daily_weather].each do |day|
        expect(day).to have_key(:date)
        expect(day).to have_key(:sunrise)
        expect(day).to have_key(:sunset)
        expect(day).to have_key(:max_temp)
        expect(day).to have_key(:min_temp)
        expect(day).to have_key(:condition)
        expect(day).to have_key(:icon)
      end
      expect(attributes[:daily_weather].count).to eq(5) # 5 days

      # Check hourly weather attributes
      attributes[:hourly_weather].each do |hour|
        expect(hour).to have_key(:time)
        expect(hour).to have_key(:temperature)
        expect(hour).to have_key(:condition)
        expect(hour).to have_key(:icon)
      end
      expect(attributes[:hourly_weather].count).to eq(24) # 24 hours
    end
  end
end
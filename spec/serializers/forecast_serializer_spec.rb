require 'rails_helper'

RSpec.describe ForecastSerializer do
  it 'serializes the weather data correctly' do
    weather_data = JSON.parse(File.read('spec/fixtures/weather_response.json'), symbolize_names: true)
    serialized_data = ForecastSerializer.new(weather_data).serializable_hash

    expect(serialized_data).to be_a(Hash)


    # data > id, type, attributes
    expect(serialized_data).to have_key(:data)
    expect(serialized_data[:data]).to be_a(Hash)
    expect(serialized_data[:data]).to have_key(:id)
    expect(serialized_data[:data][:id]).to eq(nil)
    
    expect(serialized_data[:data]).to have_key(:type)
    expect(serialized_data[:data][:type]).to eq(:forecast)

    expect(serialized_data[:data]).to have_key(:attributes)
    expect(serialized_data[:data][:attributes]).to be_a(Hash)

    
    # attribute > current_weather
    expect(serialized_data[:data][:attributes]).to have_key(:current_weather)
    expect(serialized_data[:data][:attributes][:current_weather]).to have_key(:last_updated)
    expect(serialized_data[:data][:attributes][:current_weather]).to have_key(:temperature)
    expect(serialized_data[:data][:attributes][:current_weather]).to have_key(:feels_like)

    expect(serialized_data[:data][:attributes][:current_weather]).to have_key(:humidity)
    expect(serialized_data[:data][:attributes][:current_weather][:humidity]).to be_a(Integer)

    expect(serialized_data[:data][:attributes][:current_weather]).to have_key(:uvi)
    expect(serialized_data[:data][:attributes][:current_weather][:uvi]).to be_a(Float)

    expect(serialized_data[:data][:attributes][:current_weather]).to have_key(:visibility)
    expect(serialized_data[:data][:attributes][:current_weather][:visibility]).to be_a(Float)

    expect(serialized_data[:data][:attributes][:current_weather]).to have_key(:condition)

    expect(serialized_data[:data][:attributes][:current_weather]).to have_key(:icon)

    # attribute > daily_weather, randomly checking that first element has correct date based on fixture
    expect(serialized_data[:data][:attributes]).to have_key(:daily_weather)
    expect(serialized_data[:data][:attributes][:daily_weather]).to be_an(Array)
    expect(serialized_data[:data][:attributes][:daily_weather].count).to eq(5)

    expect(serialized_data[:data][:attributes][:daily_weather].first).to have_key(:date)
    expect(serialized_data[:data][:attributes][:daily_weather].first[:date]).to eq("2024-09-22")


    expect(serialized_data[:data][:attributes][:daily_weather].first).to have_key(:sunrise)
    expect(serialized_data[:data][:attributes][:daily_weather].first).to have_key(:sunset)
    expect(serialized_data[:data][:attributes][:daily_weather].first).to have_key(:max_temp)
    expect(serialized_data[:data][:attributes][:daily_weather].first).to have_key(:min_temp)
    expect(serialized_data[:data][:attributes][:daily_weather].first).to have_key(:condition)
    expect(serialized_data[:data][:attributes][:daily_weather].first).to have_key(:icon)


    #attribute > hourly_weather, checking that extracted hour[:time] is correctly formatted
    expect(serialized_data[:data][:attributes]).to have_key(:hourly_weather)

    expect(serialized_data[:data][:attributes][:hourly_weather]).to be_an(Array)
    expect(serialized_data[:data][:attributes][:hourly_weather].count).to eq(24)

    expect(serialized_data[:data][:attributes][:hourly_weather].first).to have_key(:time)
    expect(serialized_data[:data][:attributes][:hourly_weather].first[:time]).to eq("00:00") #human readable time

    expect(serialized_data[:data][:attributes][:hourly_weather].first).to have_key(:temperature)
    expect(serialized_data[:data][:attributes][:hourly_weather].first).to have_key(:condition)
    expect(serialized_data[:data][:attributes][:hourly_weather].first).to have_key(:icon)
  end

  
  
  it 'does not include unnecessary info' do
    weather_data = JSON.parse(File.read('spec/fixtures/weather_response.json'), symbolize_names: true)
    serialized_data = ForecastSerializer.new(weather_data).serializable_hash

    expect(serialized_data).not_to have_key(:location)
    expect(serialized_data).not_to have_key(:current)
    expect(serialized_data).not_to have_key(:forecast)
    expect(serialized_data).not_to have_key(:forecastday)
    expect(serialized_data).not_to have_key(:astro)
    expect(serialized_data).not_to have_key(:hour)
    
  end
end
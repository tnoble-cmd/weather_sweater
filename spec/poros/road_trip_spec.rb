require 'rails_helper'

RSpec.describe 'Road Trip Facade' do
  it 'can create a road trip object' do
   


    poro = RoadTrip.new({formattedTime: '01:00:00', time:3600}, 'Denver, CO', 'Pueblo, CO')

    expect(poro).to be_a(RoadTrip)

    expect(poro.start_city).to eq('Denver, CO')
    expect(poro.end_city).to eq('Pueblo, CO')
    expect(poro.travel_time).to eq('01:00:00')
    expect(poro.seconds).to eq(3600)
    expect(poro.arrival_time_date).to eq(Time.now.strftime('%Y-%m-%d'))
    expect(poro.arrival_time_date).to be_a(String)

    #theoretically, Time.now will automatically increment both the date when passing midnight
    expect(poro.arrival_time_hour).to be_a(String)
  end

  describe 'arrival_time_calculator' do
    it 'can calculate the arrival time' do
      poro = RoadTrip.new({formattedTime: '01:00:00', time:3600}, 'Denver, CO', 'Pueblo, CO')

      expect(poro.arrival_time_calculator(3600)).to be_a(Time)
    end
  end
end
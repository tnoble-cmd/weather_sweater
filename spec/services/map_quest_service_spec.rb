require 'rails_helper'

RSpec.describe MapQuestService do
  before :each do
    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest[:key]}&location=denver,co").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.12.0'
           }).
         to_return(status: 200, body: File.read("spec/fixtures/map_quest_response.json"), headers: {'Content-Type' => 'application/json'})
  end

  it 'can get coordinates' do
    # service = MapQuestService.get_coordinates('denver,co')
    # result = service.get_coordinates
    result = MapQuestService.get_coordinates('denver,co')

    #structured right
    expect(result).to be_a(Hash)

    # expecting response to have latLng hash with :lat and :lng keys
    expect(result).to have_key(:lat)
    expect(result).to have_key(:lng)

    expect(result[:lat]).to eq(39.74001)
    expect(result[:lng]).to eq(-104.99202)
  end

  it 'can get directions' do
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=denver,co&key=#{Rails.application.credentials.map_quest[:key]}&to=boulder,co").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.12.0'
           }).
         to_return(status: 200, body: File.read("spec/fixtures/map_quest_directions_fixture.json"), headers: {'Content-Type' => 'application/json'})


    result = MapQuestService.get_directions('denver,co', 'boulder,co')

    expect(result).to be_a(Hash)
    expect(result).to have_key(:time)
    expect(result).to have_key(:legs)
    expect(result[:legs]).to be_a(Array)
  end
end
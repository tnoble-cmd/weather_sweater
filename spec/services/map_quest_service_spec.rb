require 'rails_helper'

RSpec.describe MapQuestService do
  before :each do
    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key=FDZWOBXB50jP64RpfVW8G5fWFCZxaizj&location=denver,co").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.12.0'
           }).
         to_return(status: 200, body: File.read("spec/fixtures/mapquest_response.json"), headers: {'Content-Type' => 'application/json'})
  end
  it 'exists' do
    service = MapQuestService.new('denver,co')
    expect(service).to be_a(MapQuestService)
  end

  it 'can get coordinates' do
    service = MapQuestService.new('denver,co')
    result = service.get_coordinates

    expect(result).to be_a(Hash)

    # expecting response to have latLng hash with :lat and :lng keys
    expect(result).to have_key(:lat)
    expect(result).to have_key(:lng)

    expect(result[:lat]).to eq(39.74001)
    expect(result[:lng]).to eq(-104.99202)
  end
end
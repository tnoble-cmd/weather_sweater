class MapQuestService
  def initialize(location)
    @location = location
    
  end
  
  
  def get_coordinates
    conn = Faraday.new(url: 'http://www.mapquestapi.com')
    response = conn.get('/geocoding/v1/address') do |req|
      req.params['key'] = Rails.application.credentials.map_quest[:key]
      req.params['location'] = @location
    end
    data = JSON.parse(response.body, symbolize_names: true)
    data[:results].first[:locations].first[:latLng]
  end
end
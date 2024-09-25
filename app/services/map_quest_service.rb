class MapQuestService
  # def initialize(location)
  #   @location = location
    
  # end
  
  
  def self.get_coordinates(location)
    conn = Faraday.new(url: 'http://www.mapquestapi.com')
    response = conn.get('/geocoding/v1/address') do |req|
      req.params['key'] = Rails.application.credentials.map_quest[:key]
      req.params['location'] = location
    end
    data = JSON.parse(response.body, symbolize_names: true)
    data[:results].first[:locations].first[:latLng]
  end

  def self.get_directions(origin, destination)
    conn = Faraday.new(url: 'http://www.mapquestapi.com')
    response = conn.get('/directions/v2/route') do |req|
      req.params['key'] = Rails.application.credentials.map_quest[:key]
      req.params['from'] = origin
      req.params['to'] = destination
    end
    data = JSON.parse(response.body, symbolize_names: true)
    data[:route]
  end
end
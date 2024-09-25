class Api::V1::RoadTripController < ApplicationController
  def create
    user = User.find_by(api_key: params[:api_key])
    if user
      road_trip = RoadTripFacade.get_road_trip(params[:origin], params[:destination])
    else
      render json: { error: 'Invalid Api Key' }, status: :unauthorized
    end
  end
end
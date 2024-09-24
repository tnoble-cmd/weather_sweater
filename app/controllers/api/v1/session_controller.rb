class Api::V1::SessionController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if params[:email].blank? || params[:password].blank?
      render json: { errors: 'Please fill in required fields' }, status: :unauthorized
      return
    end

    if user && user.authenticate(params[:password])
      render json: UsersSerializer.new(user), status: :ok
    else
      render json: { errors: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
class Api::V1::UsersController < ApplicationController
  def create
  
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
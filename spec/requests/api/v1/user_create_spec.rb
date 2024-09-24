require 'rails_helper'

RSpec.describe 'User Create API' do
  describe 'happy path' do
    
    it 'creates a user and returns an api key' do
      
      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = {
        "user": {
          "email": "whatever@example.com",
          "password": "password",
          "password_confirmation": "password"
        }
      }

      post '/api/v1/users', headers: headers, params: JSON.generate(body)
      expect(response).to be_successful
      expect(response.status).to eq(201) # 201 Created
      
      parsed_response = JSON.parse(response.body, symbolize_names: true)

      #checking structure
      expect(parsed_response).to be_a Hash
      expect(parsed_response).to have_key(:data)
      expect(parsed_response[:data]).to be_a Hash

      expect(parsed_response[:data]).to have_key(:id)
      expect(parsed_response[:data][:id]).to be_a String
      expect(parsed_response[:data][:id]).to eq(User.last.id.to_s)

      expect(parsed_response[:data]).to have_key(:type)
      expect(parsed_response[:data][:type]).to be_a String
      expect(parsed_response[:data][:type]).to eq('user')

      expect(parsed_response[:data]).to have_key(:attributes)
      expect(parsed_response[:data][:attributes]).to be_a Hash

      expect(parsed_response[:data][:attributes]).to have_key(:email)
      expect(parsed_response[:data][:attributes][:email]).to be_a String

      expect(parsed_response[:data][:attributes]).to have_key(:api_key)
      expect(parsed_response[:data][:attributes][:api_key]).to be_a String
      expect(parsed_response[:data][:attributes][:api_key].length).to eq(32)
      expect(parsed_response[:data][:attributes][:api_key]).to eq(User.last.api_key)

      # Ensure password is not returned
      expect(parsed_response[:data][:attributes]).to_not have_key(:password)
    end
  end

  describe 'sad path' do
    it 'returns an error if passwords do not match' do
      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = {
        "user": {
          "email": "whatever@example.com",
          "password": "pass",
          "password_confirmation": "password"
        }
      }

      post '/api/v1/users', headers: headers, params: JSON.generate(body)

      expect(response.status).to eq(400) # 400 Bad Request
      
      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_response).to be_a Hash
      expect(parsed_response).to have_key(:errors)
      expect(parsed_response[:errors]).to be_a String
      expect(parsed_response[:errors]).to include("Password confirmation doesn't match Password")
    end

    it 'returns an error if email is not unique' do

      User.create(email:'what@email.com', password: 'password', password_confirmation: 'password')

      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = {
        "user": {
          "email": "what@email.com",
          "password": "password",
          "password_confirmation": "password"
        }
      }

      post '/api/v1/users', headers: headers, params: JSON.generate(body)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400) # 400 Bad Request
      expect(parsed_response).to be_a Hash
      expect(parsed_response).to have_key(:errors)
      expect(parsed_response[:errors]).to be_a String
      expect(parsed_response[:errors]).to include("Email has already been taken")
    end

    it 'returns an error if email is missing' do

      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = {
        "user": {
          "email": "",
          "password": "password",
          "password_confirmation": "password"
        }
      }

      post '/api/v1/users', headers: headers, params: JSON.generate(body)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400) # 400 Bad Request
      expect(parsed_response).to be_a Hash
      expect(parsed_response).to have_key(:errors)
      expect(parsed_response[:errors]).to be_a String
      expect(parsed_response[:errors]).to include("Email can't be blank")
    end
  end
end
require 'rails_helper'

RSpec.describe 'Session API' do
  describe 'happy path' do

    it 'creates a session and returns an api key' do
      User.create(email: 'this@email.com', password: 'password', password_confirmation: 'password')

      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = 
      {
        "email": "this@email.com",
        "password": "password"
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)
      expect(response).to be_successful

      expect(response.status).to eq(200) # 200 OK
      
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
      expect(parsed_response[:data][:attributes][:api_key]).to eq(User.last.api_key)
      expect(parsed_response[:data][:attributes][:api_key].length).to eq(32)

      # Ensure password is not returned
      expect(parsed_response[:data][:attributes]).to_not have_key(:password)
    end
  end

  describe 'sad path' do
    it 'returns an error if email does not exist' do
      User.create(email: 'this@email.com', password: 'password', password_confirmation: 'password')

      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = 
      {
        "email": "this123@email.com",
        "password": "password"
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401) # 401 Unauthorized
      expect(parsed_response).to have_key(:errors)
      expect(parsed_response[:errors]).to eq('Invalid email or password')
    end

    it 'returns an error if password is incorrect' do
      User.create(email: 'this@email.com', password: 'password', password_confirmation: 'password')

      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = 
      {
        "email": "this123@email.com",
        "password": "pass"
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401) # 401 Unauthorized
      expect(parsed_response).to have_key(:errors)
      expect(parsed_response[:errors]).to eq('Invalid email or password')
    end

    it 'returns an error if email is missing' do
      User.create(email: 'this@email.com', password: 'password', password_confirmation: 'password')

      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = 
      {
        "email": "",
        "password": "pass"
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401) # 401 Unauthorized
      expect(parsed_response).to have_key(:errors)
      expect(parsed_response[:errors]).to eq('Please fill in required fields')
    end

    it 'returns an error if password is missing' do
      User.create(email: 'this@email.com', password: 'password', password_confirmation: 'password')

      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = 
      {
        "email": "email@email.com",
        "password": ""
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401) # 401 Unauthorized
      expect(parsed_response).to have_key(:errors)
      expect(parsed_response[:errors]).to eq('Please fill in required fields')
    end

    it 'returns an error if email and password are missing' do
      User.create(email: 'this@email.com', password: 'password', password_confirmation: 'password')

      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      body = 
      {
        "email": "",
        "password": ""
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401) # 401 Unauthorized
      expect(parsed_response).to have_key(:errors)
      expect(parsed_response[:errors]).to eq('Please fill in required fields')
    end
  end
end
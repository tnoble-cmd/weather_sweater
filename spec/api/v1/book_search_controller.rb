require 'rails_helper'

RSpec.describe 'Book Search API', type: :request do
  before do
    stub_request(:get, /mapquestapi.com/).to_return(
      body: File.read('spec/fixtures/map_quest_response.json'),
      headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:get, /weatherapi.com/).to_return(
      body: File.read('spec/fixtures/weather_response.json'),
      headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:get, /openlibrary.org/).to_return(
      body: File.read('spec/fixtures/book_search_response.json'),
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  it 'can return a correct response' do
    get '/api/v1/book-search', params: { location: 'denver,co', quantity: 5 }

    expect(response).to be_successful
    expect(response.status).to eq(200)

    books = JSON.parse(response.body, symbolize_names: true)

    expect(books).to be_a(Hash)
    expect(books[:data]).to have_key(:id)
    expect(books[:data]).to have_key(:type)
    expect(books[:data][:type]).to eq('books')
    expect(books[:data][:attributes]).to have_key(:destination)
    expect(books[:data][:attributes]).to have_key(:forecast)
    expect(books[:data][:attributes]).to have_key(:total_books_found)
    expect(books[:data][:attributes]).to have_key(:books)

    forecast = books[:data][:attributes][:forecast]
    expect(forecast).to have_key(:summary)
    expect(forecast).to have_key(:temperature)

    book_list = books[:data][:attributes][:books]
    expect(book_list).to be_an(Array)
    expect(book_list.first).to have_key(:isbn)
    expect(book_list.first).to have_key(:title)
    expect(book_list.first).to have_key(:publisher)
  end

  it 'returns an error if quantity is less than or equal to 0' do
    get '/api/v1/book-search', params: { location: 'denver,co', quantity: 0 }

    expect(response.status).to eq(400)
    expect(response.body).to eq({ error: 'Quantity must be greater than 0' }.to_json)
  end
end
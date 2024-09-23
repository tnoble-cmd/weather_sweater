require 'rails_helper'

RSpec.describe BookSerializer do
  it 'can serialize a book search response' do
    book = {
      destination: 'Denver, CO',
      forecast: {
        summary: 'Cloudy',
        temperature: '45'
      },
      total_books_found: 5,
      books: [
        {
          isbn: '12345',
          title: 'A Book Title',
          publisher: 'Some Publisher'
        }
      ]
    }

    serialized = BookSerializer.new(book).serializable_hash

    expect(serialized).to be_a(Hash)
    expect(serialized[:data][:id]).to eq(nil)
    expect(serialized[:data][:type]).to eq(:books)
    expect(serialized[:data][:attributes][:destination]).to eq('Denver, CO')
    expect(serialized[:data][:attributes][:forecast]).to eq({summary: 'Cloudy', temperature: '45'})
    expect(serialized[:data][:attributes][:total_books_found]).to eq(5)
    expect(serialized[:data][:attributes][:books]).to be_an(Array)
    expect(serialized[:data][:attributes][:books].first).to eq({isbn: '12345', title: 'A Book Title', publisher: 'Some Publisher'})
  end
end
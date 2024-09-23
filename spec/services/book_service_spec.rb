require 'rails_helper'

RSpec.describe BookService do
  it 'exists' do
    book_service = BookService.new('denver,co', 5)

    expect(book_service).to be_a(BookService)
  end

  it 'can make a call to the Open Library API' do
    stub_request(:get, "https://openlibrary.org/search.json?offset=5&limit=5&q=denver,co").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v2.12.0'}).
      to_return(status: 200, body: File.read('spec/fixtures/book_search_response.json'))

    book_service = BookService.new('denver,co', 5)

    expect(book_service.get_books).to be_a(Hash)
    expect(book_service.get_books[:docs].count).to eq(5)

    #checking for initial attributes i need for serializer
    first_book = book_service.get_books[:docs].first
    expect(first_book).to have_key(:title)
    expect(first_book[:title]).to be_a(String)
    expect(first_book).to have_key(:author_name)
    expect(first_book[:author_name]).to be_an(Array)
    expect(first_book).to have_key(:isbn)
    expect(first_book).to have_key(:publisher)
    expect(book_service.get_books).to have_key(:numFound)
  end

  it 'can format the book data' do
    stub_request(:get, "https://openlibrary.org/search.json?offset=5&limit=5&q=denver,co").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v2.12.0'}).
      to_return(status: 200, body: File.read('spec/fixtures/book_search_response.json'))

    book_service = BookService.new('denver,co', 5)

    expect(book_service.formatted_books).to be_a(Hash)
    expect(book_service.formatted_books[:destination]).to eq('denver,co')
    expect(book_service.formatted_books[:total_books_found]).to eq(769)
    expect(book_service.formatted_books[:books].count).to eq(5)
    expect(book_service.formatted_books[:books].first).to have_key(:isbn)
    expect(book_service.formatted_books[:books].first).to have_key(:title)
    expect(book_service.formatted_books[:books].first).to have_key(:publisher)
  end
end
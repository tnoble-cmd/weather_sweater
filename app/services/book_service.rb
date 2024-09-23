class BookService
  def initialize(query, quantity)
    @query = query
    @quantity = quantity
  end



  def get_books
    conn = Faraday.new(url: 'https://openlibrary.org')

    response = conn.get('/search.json') do |req|
      req.params['q'] = @query
      req.params['offset'] = @quantity
      req.params['limit'] = @quantity
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def formatted_books
    books = get_books[:docs]
    {
      destination: @query,
      total_books_found: get_books[:numFound],
      books: books.map do |book|
        {
          isbn: book[:isbn],
          title: book[:title],
          publisher: book[:publisher]
        }
      end
    }
  end
end
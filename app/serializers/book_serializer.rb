class BookSerializer
  include JSONAPI::Serializer

  set_id { nil }
  set_type :books

  attribute :destination do |object|
    object[:destination]
  end

  attribute :forecast do |object|
    {
      summary: object[:forecast][:summary],
      temperature: object[:forecast][:temperature]
    }
  end

  attribute :total_books_found do |object|
    object[:total_books_found]
  end

  attribute :books do |object|
    object[:books].map do |book|
      {
        isbn: book[:isbn],
        title: book[:title],
        publisher: book[:publisher]
      }
    end
  end
end
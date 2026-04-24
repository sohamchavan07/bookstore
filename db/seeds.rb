# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

categories_data = {
  'Fiction' => [
    { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', price: 499.00, published_on: '1925-04-10' },
    { title: 'To Kill a Mockingbird', author: 'Harper Lee', price: 399.00, published_on: '1960-07-11' },
    { title: '1984', author: 'George Orwell', price: 299.00, published_on: '1949-06-08' },
    { title: 'Pride and Prejudice', author: 'Jane Austen', price: 350.00, published_on: '1813-01-28' },
    { title: 'The Catcher in the Rye', author: 'J.D. Salinger', price: 450.00, published_on: '1951-07-16' },
    { title: 'The Hobbit', author: 'J.R.R. Tolkien', price: 550.00, published_on: '1937-09-21' },
    { title: 'Fahrenheit 451', author: 'Ray Bradbury', price: 320.00, published_on: '1953-10-19' }
  ],
  'Non-Fiction' => [
    { title: 'Sapiens: A Brief History of Humankind', author: 'Yuval Noah Harari', price: 599.00, published_on: '2011-01-01' },
    { title: 'Educated', author: 'Tara Westover', price: 450.00, published_on: '2018-02-20' },
    { title: 'The Immortal Life of Henrietta Lacks', author: 'Rebecca Skloot', price: 350.00, published_on: '2010-02-02' },
    { title: 'Thinking, Fast and Slow', author: 'Daniel Kahneman', price: 500.00, published_on: '2011-10-25' },
    { title: 'Becoming', author: 'Michelle Obama', price: 600.00, published_on: '2018-11-13' },
    { title: 'The Tipping Point', author: 'Malcolm Gladwell', price: 420.00, published_on: '2000-03-01' }
  ],
  'Science' => [
    { title: 'A Brief History of Time', author: 'Stephen Hawking', price: 499.00, published_on: '1988-04-01' },
    { title: 'Cosmos', author: 'Carl Sagan', price: 550.00, published_on: '1980-09-28' },
    { title: 'The Selfish Gene', author: 'Richard Dawkins', price: 420.00, published_on: '1976-01-01' },
    { title: 'Astrophysics for People in a Hurry', author: 'Neil deGrasse Tyson', price: 400.00, published_on: '2017-05-02' },
    { title: 'The Double Helix', author: 'James D. Watson', price: 380.00, published_on: '1968-01-01' },
    { title: 'Silent Spring', author: 'Rachel Carson', price: 450.00, published_on: '1962-09-27' }
  ],
  'History' => [
    { title: 'Guns, Germs, and Steel', author: 'Jared Diamond', price: 550.00, published_on: '1997-01-01' },
    { title: 'The Silk Roads', author: 'Peter Frankopan', price: 650.00, published_on: '2015-01-01' },
    { title: 'Team of Rivals', author: 'Doris Kearns Goodwin', price: 700.00, published_on: '2005-10-25' },
    { title: 'A People\'s History of the United States', author: 'Howard Zinn', price: 480.00, published_on: '1980-01-01' },
    { title: 'The Wright Brothers', author: 'David McCullough', price: 520.00, published_on: '2015-05-05' },
    { title: 'The Rise and Fall of the Third Reich', author: 'William L. Shirer', price: 800.00, published_on: '1960-10-17' }
  ]
}

puts 'Seeding categories and books...'

categories_data.each do |category_name, books|
  category = Category.find_or_create_by!(name: category_name)
  books.each do |book_attrs|
    book = category.books.find_or_initialize_by(title: book_attrs[:title])
    book.update!(book_attrs)
  end
end

puts "Seed completed: Created/Updated #{Category.count} categories and #{Book.count} books."

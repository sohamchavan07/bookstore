require 'rails_helper'

RSpec.describe "Book Search and Filter", type: :system do
  before do
    driven_by(:rack_test)
    @fiction = create(:category, name: "Fiction")
    @science = create(:category, name: "Science")
    
    @book1 = create(:book, title: "The Great Gatsby", author: "F. Scott Fitzgerald", category: @fiction)
    @book2 = create(:book, title: "A Brief History of Time", author: "Stephen Hawking", category: @science)
    @book3 = create(:book, title: "The Great Alone", author: "Kristin Hannah", category: @fiction)
  end

  it "allows searching by title" do
    visit books_path
    
    fill_in "Search by title or author", with: "Gatsby"
    click_on "Search"
    
    expect(page).to have_content("The Great Gatsby")
    expect(page).not_to have_content("A Brief History of Time")
    expect(page).not_to have_content("The Great Alone")
  end

  it "allows filtering by category" do
    visit books_path
    
    select "Science", from: "Filter by Category"
    click_on "Search"
    
    expect(page).to have_content("A Brief History of Time")
    expect(page).not_to have_content("The Great Gatsby")
    expect(page).not_to have_content("The Great Alone")
  end

  it "combines search and category filter" do
    visit books_path
    
    fill_in "Search by title or author", with: "Great"
    select "Fiction", from: "Filter by Category"
    click_on "Search"
    
    expect(page).to have_content("The Great Gatsby")
    expect(page).to have_content("The Great Alone")
    expect(page).not_to have_content("A Brief History of Time")
  end

  it "can clear filters" do
    visit books_path
    
    fill_in "Search by title or author", with: "Gatsby"
    click_on "Search"
    
    expect(page).not_to have_content("A Brief History of Time")
    
    click_on "Clear"
    
    expect(page).to have_content("The Great Gatsby")
    expect(page).to have_content("A Brief History of Time")
  end
end

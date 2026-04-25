# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Books::SearchBooksService do
  before do
    Book.destroy_all
    Category.destroy_all
  end

  let(:category_a) { create(:category) }
  let(:category_b) { create(:category) }

  let!(:book_a) { create(:book, title: 'Clean Code',     author: 'Martin', category: category_a) }
  let!(:book_b) { create(:book, title: 'The Pragmatist', author: 'Hunt',   category: category_b) }
  let!(:book_c) { create(:book, title: 'Clean Architecture', author: 'Martin', category: category_a) }

  subject(:result) { described_class.call(query: query, category_id: category_id) }

  let(:query)       { nil }
  let(:category_id) { nil }

  context 'with no filters' do
    it 'returns all books' do
      expect(result.payload.count).to eq(3)
    end

    it 'is always successful' do
      expect(result.success?).to be true
    end
  end

  context 'with a search query' do
    let(:query) { 'Clean' }

    it 'returns only books matching the query' do
      expect(result.payload).to contain_exactly(book_a, book_c)
    end
  end

  context 'with a category_id filter' do
    let(:category_id) { category_b.id }

    it 'returns only books in that category' do
      expect(result.payload).to contain_exactly(book_b)
    end
  end

  context 'with both query and category_id' do
    let(:query)       { 'Martin' }
    let(:category_id) { category_a.id }

    it 'applies both filters together' do
      expect(result.payload).to contain_exactly(book_a, book_c)
    end
  end

  context 'when no books match' do
    let(:query) { 'NonExistentTitle' }

    it 'returns an empty relation' do
      expect(result.payload).to be_empty
    end

    it 'is still successful' do
      expect(result.success?).to be true
    end
  end
end

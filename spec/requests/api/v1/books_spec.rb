# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Books', type: :request do
  # create a real category to use in tests
  let!(:category) { create(:category) }
  # create 3 books attached to that category
  let!(:books) { create_list(:book, 3, category: category) }

  # helper parsing functions to avoid "hash vs array" issues
  def parsed_json
    JSON.parse(response.body)
  end

  def data
    parsed_json['data']
  end

  def data_id
    data.is_a?(Array) ? data.first['id'] : data['id']
  end

  describe 'GET /api/v1/books' do
    it 'returns all books' do
      get '/api/v1/books'
      # debug: puts response.body if you need to inspect JSON
      expect(response).to have_http_status(:ok)
      expect(data.size).to eq(3)
    end
  end

  describe 'GET /api/v1/books/:id' do
    it 'returns a single book' do
      book = books.first
      get "/api/v1/books/#{book.id}"

      expect(response).to have_http_status(:ok)
      # data here should be a Hash (single resource)
      expect(parsed_json['data']['id']).to eq(book.id.to_s)
    end

    it 'returns 404 if book not found' do
      get '/api/v1/books/9999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/books' do
    it 'creates a new book' do
      post '/api/v1/books', params: {
        book: {
          title: 'New Book',
          author: 'John',
          price: 199,
          category_id: category.id # <--- use the real category id
        }
      }

      expect(response).to have_http_status(:created)
      json = parsed_json
      expect(json['data']['attributes']['title']).to eq('New Book')
    end

    it 'returns errors if validation fails' do
      post '/api/v1/books', params: { book: { title: '' } }
      expect(response).to have_http_status(:unprocessable_content).or have_http_status(422)
      # NOTE: RSpec/warnings about :unprocessable_entity deprecation — 422 numeric is safe
    end
  end
end

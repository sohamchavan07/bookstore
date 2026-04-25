# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Books::CreateBookService do
  subject(:result) { described_class.call(params) }

  let(:category) { create(:category) }

  context 'when params are valid' do
    let(:params) do
      { title: 'Clean Code', author: 'Robert C. Martin', price: 499, category_id: category.id }
    end

    it 'returns a successful result' do
      expect(result.success?).to be true
    end

    it 'returns the persisted book as payload' do
      expect(result.payload).to be_a(Book)
      expect(result.payload).to be_persisted
    end

    it 'persists the book with correct attributes' do
      expect(result.payload.title).to eq('Clean Code')
      expect(result.payload.author).to eq('Robert C. Martin')
      expect(result.payload.price).to eq(499)
    end
  end

  context 'when params are invalid' do
    let(:params) { { title: '', author: '', price: -1, category_id: category.id } }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'returns an error message' do
      expect(result.error).to be_present
    end

    it 'does not persist a book' do
      expect { result }.not_to change(Book, :count)
    end
  end
end

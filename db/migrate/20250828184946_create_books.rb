# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.decimal :price, precision: 10, scale: 2
      t.date :published_on

      t.timestamps
    end
  end
end

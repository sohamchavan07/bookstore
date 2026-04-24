class ChangeCategoryIdInBooksToNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :books, :category_id, false
  end
end

class SeedCategoriesIfMissing < ActiveRecord::Migration[8.0]
  def up
    [ 'Fiction', 'Non-Fiction', 'Science', 'History' ].each do |name|
      Category.find_or_create_by!(name: name)
    end
  end

  def down
    # No-op: categories shouldn't be removed once seeded
  end
end

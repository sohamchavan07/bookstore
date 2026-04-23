class AddSupabaseIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :supabase_id, :string
    add_index :users, :supabase_id
  end
end

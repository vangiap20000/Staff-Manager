class AddCreatedByToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :created_by, foreign_key: { to_table: :users }, type: :bigint
  end
end

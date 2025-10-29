class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :avatar
      t.string :phone_number, limit: 13
      t.references :team, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end

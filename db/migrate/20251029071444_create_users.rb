class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null:false
      t.string :email, null:false
      t.string :phone_number, limit: 13
      t.references :team, null: false, foreign_key: true
      t.integer :role, comment: "1: super admin, 2: admin, 3: member"
      t.string :password_digest  

      t.timestamps
    end
  end
end

class CreateTeams < ActiveRecord::Migration[8.1]
  def change
    create_table :teams do |t|
      t.string :name, null:false
      t.integer :max_member
      
      t.timestamps
    end
  end
end

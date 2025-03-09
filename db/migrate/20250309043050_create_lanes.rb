class CreateLanes < ActiveRecord::Migration[7.2]
  def change
    create_table :lanes do |t|
      t.references :race, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.integer :lane_number
      
      t.timestamps
    end
  end
end

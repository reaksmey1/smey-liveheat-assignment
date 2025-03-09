class CreateRaces < ActiveRecord::Migration[7.2]
  def change
    create_table :races do |t|
      t.string :name, null: false
      t.integer :number_of_lanes

      t.timestamps
    end
  end
end

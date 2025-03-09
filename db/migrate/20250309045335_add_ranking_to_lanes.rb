class AddRankingToLanes < ActiveRecord::Migration[7.2]
  def change
    add_column :lanes, :ranking, :integer
  end
end

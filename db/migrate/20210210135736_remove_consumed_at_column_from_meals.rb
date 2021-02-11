class RemoveConsumedAtColumnFromMeals < ActiveRecord::Migration[6.1]
  def change
    remove_column :meals, :consumed_at, :datetime
  end
end

class RemoveBrandNameColumnFromMeals < ActiveRecord::Migration[6.1]
  def change
    remove_column :meals, :brand_name, :string
  end
end

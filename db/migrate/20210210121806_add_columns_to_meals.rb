class AddColumnsToMeals < ActiveRecord::Migration[6.1]
  def change
    add_column :meals, :brand_name, :string
    add_column :meals, :thumbnail, :string
    add_column :meals, :quantity, :integer
    add_column :meals, :units, :string
    add_column :meals, :consumed_at, :datetime
  end
end

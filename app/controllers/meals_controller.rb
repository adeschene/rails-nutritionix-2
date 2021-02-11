class MealsController < ApplicationController
  def index
    @meals = Meal.all
  end

  def create
    @meal = Meal.new(meal_params)

    hash = NutritionixService.new.get_meal_by_name(@meal.name)

    # If API call failed, tell user and redirect
    if hash == "error"
      redirect_to meals_path, alert: "Meal description missing or invalid..."
    else # If API call worked, set meal fields and save it
      @meal.thumbnail = hash[:thumbnail]
      @meal.name      = hash[:food_name] # Re-assign meal name to food name returned from API
      @meal.quantity  = hash[:quantity]
      @meal.units     = hash[:units]
      @meal.calories  = hash[:calories]

      if @meal.save
        redirect_to meals_path, notice: "Meal successfully added."
      else
        redirect_to meals_path, alert: "Error adding meal..."
      end
    end
  end

  def destroy
    @meal = Meal.find(params[:id])
    @meal.destroy

    redirect_to meals_path, notice: "Meal successfully removed."
  end

  private
    def meal_params
      params.require(:meal).permit(:name)
    end
end

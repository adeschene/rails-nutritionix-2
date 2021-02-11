class MealsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  # Index gets the current user's meals unless they aren't signed in
  def index
    @meals = current_user.meals unless !user_signed_in?
  end

  def create
    # Add the meal to the current user's meals
    @meal = current_user.meals.build(meal_params)

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
    # Make sure that the meal we're destroying is the current user's meal
    @meal = current_user.meals.find(params[:id])
    @meal.destroy

    redirect_to meals_path, notice: "Meal successfully removed."
  end

  private
    def meal_params
      params.require(:meal).permit(:name, :user_id)
    end
end

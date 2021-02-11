class NutritionixService
  include HTTParty

  BASE_URL = "https://trackapi.nutritionix.com/v2"

  # Hash containing the headers required for API call, uses hidden ENV variables
  HEADERS = {
    'Content-Type': 'application/json',
    'x-app-id': ENV['nutritionix_app_id'],
    'x-app-key': ENV['nutritionix_app_key'],
    'x-remote-user-id': '0'
  }

  # Takes a natural language description of a meal and asks the API for a matching meal's nutrition info; returns relevent info
  def get_meal_by_name(name)
    response     = HTTParty.post("#{BASE_URL}/natural/nutrients", headers: HEADERS, body: {query: name}.to_json).to_s
    parsed       = JSON.parse(response, {symbolize_names: true})

    # If a "message" is returned by the API, an error must have occured, so just return "error" and handle it in the controller
    return parsed[:message] ? "error" : { # Otherwise extract and format a particular set of info from the API response
      thumbnail: parsed[:foods][0][:photo][:thumb], # Image of food returned from db
      food_name: parsed[:foods][0][:food_name].capitalize, # Actual name of food found in API db
      quantity:  parsed[:foods][0][:serving_qty], # Number of servings returned from API
      units:     parsed[:foods][0][:serving_unit], # Unit of measurement for servings
      calories:  parsed[:foods][0][:nf_calories] # Calories number returned from API
    }
  end
end
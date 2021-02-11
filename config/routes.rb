Rails.application.routes.draw do
  root "meals#index"

  resources :meals, only: [:index, :create, :destroy]
end

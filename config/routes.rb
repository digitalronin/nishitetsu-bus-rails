Rails.application.routes.draw do
  resources :bus_stops
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/map", to: "map#show"
  put "/map", to: "map#update"
  patch "/map", to: "map#update_journey"
end

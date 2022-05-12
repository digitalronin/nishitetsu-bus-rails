Rails.application.routes.draw do
  resources :bus_routes
  resources :bus_stops
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "map#show"

  get "/map", to: "map#show"
  put "/map", to: "map#update"
  patch "/map", to: "map#update_journey"

  get "/departures/:from/:to", to: "departures#show"

  get "/journeys", to: "journeys#index"
end

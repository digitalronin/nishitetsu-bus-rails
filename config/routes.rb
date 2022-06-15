# frozen_string_literal: true

Rails.application.routes.draw do
  resources :bus_routes
  resources :bus_stops
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/", to: redirect("/#{I18n.locale}/map")

  scope "/:locale" do
    get "/map", to: "map#show", as: "map"
    post "/map", to: "map#show"
    put "/map", to: "map#update"
    patch "/map", to: "map#update_journey"

    get "/departures/:from/:to", to: "departures#show", as: "departures"

    get "/journeys", to: "journeys#index", as: "my_journeys"
    get "/foo", to: "best_fit_journeys#index"
  end
end

Rails.application.routes.draw do
  root 'breweries#index'
  get 'kaikki_bisset', to: 'beers#index'

  resources :ratings, only: [:index, :new, :create]
  resources :beers
  resources :breweries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

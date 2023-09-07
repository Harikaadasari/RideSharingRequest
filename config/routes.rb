# config/routes.rb
Rails.application.routes.draw do
  resources :riders, only: [:create, :index, :show, :update, :destroy]
  resources :drivers, only: [:create, :index, :show, :update, :destroy]

  resources :ride_requests, only: [:create, :index, :show]

  resources :rides, only: [:index, :show, :update, :destroy] do
    member do
      post 'match'
      post 'start_ride'
      post 'complete_ride'
    end
  end

  # Route ride-related actions to RideRequestsController
  resources :ride_requests, only: [:create, :index, :show] do
    post '/ride_requests/:id/match', to: 'ride_requests#match'
    post 'match', on: :member, to: 'ride_requests#match'
    post 'start_ride', on: :member, to: 'ride_requests#start_ride'
    post 'complete_ride', on: :member, to: 'ride_requests#complete_ride'
    get 'calculate_distance', on: :member, to: 'ride_requests#calculate_distance' # Add this line
    get 'calculate_ride_details', on: :member, to: 'ride_requests#calculate_ride_details' # Add this line
  end
end


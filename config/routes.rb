Rails.application.routes.draw do
  resources :reservations
  root "home#home"
  resources :bookings
  resources :apartments
  post 'apartments/populate'
  get 'apartments/populate'

  resources :missions
  post 'mission/generate'
  get 'mission/generate'

end

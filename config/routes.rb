require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "turns#index"
  resources :turns

  mount Sidekiq::Web => "/sidekiq"
end

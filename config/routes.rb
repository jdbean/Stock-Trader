Rails.application.routes.draw do
  devise_for :users
  root 'portfolios#index'
  # resources :portfolios, only: [:index], 
  get "portfolio" => "portfolios#index"
  resources :transactions, only: [:index, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

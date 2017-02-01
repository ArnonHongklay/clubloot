Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # namespace :api, path: '/', contraints: { subdomain: 'api' } do
  devise_for :users

  root 'courses#index'
  resources :ledgers
  resources :programs
  resources :templates do
    resources :questions do
      resources :answers
    end
    resources :contests
  end
  # end
end

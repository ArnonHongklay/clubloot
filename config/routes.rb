Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, path: '/', contraints: { subdomain: 'api' } do
    devise_for :users

    resources :contests
    resources :answers
    resources :programs
    resources :questions
    resources :ledgers
    resources :templates
  end
end

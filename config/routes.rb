Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, path: '/', contraints: { subdomain: 'api' } do
    devise_for :users

    # resources :programs do
    #   resources :templates do
    #   end
    # end
  end
end

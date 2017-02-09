Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root 'systems#index'
  get 'systems/index'

  resources :systems, only: :index do
    collection do
      resources :ledgers
      resources :programs do
        resources :templates do
          resources :questions do
            resources :answers
          end
          resources :contests
        end
      end
    end
  end
end

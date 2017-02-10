Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  constraints(subdomain: App.admin_host)  do
    devise_for :users

    root 'systems#index'
    get 'systems/index'

    resources :systems, only: :index do
      collection do
        resources :ledgers
        resources :programs
        resources :templates do
          resources :questions do
            resources :answers
          end
          resources :contests
        end
      end
    end
  end

  constraints(subdomain: App.api_host) do
    mount Clubloot::API => '/'
  end
end

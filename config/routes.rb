Rails.application.routes.draw do

  get 'landing/index'

  constraints(subdomain: App.host('api')) do
    # mount Sidekiq::Web => '/workers'
    # mount ActionCable.server => "/cable"

    mount ApplicationAPI, at: '/'
    mount GrapeSwaggerRails::Engine, at: '/explorer'
  end

  constraints(subdomain: App.host('admin'))  do
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

  constraints(subdomain: App.host(''))  do
    root 'landing#index'
  end
end

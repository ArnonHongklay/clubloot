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
        resources :announcements
        resources :ledgers
        resources :programs do
          put 'toggle_status', on: :member
        end
        resources :templates do
          resources :questions do
            collection do
              get 'edit_all'
              put 'update_all'
            end
            member do
              put 'answer'
            end
            resources :answers
          end
          resources :contests
        end
        resources :prizes
      end
    end
  end

  constraints(subdomain: App.host(''))  do
    root 'landing#index'
  end
end

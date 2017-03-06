Rails.application.routes.draw do
  get 'landing/index'
  post 'landing/subscribes'

  constraints(subdomain: App.host('api')) do
    mount Sidekiq::Web => '/workers'
    mount ActionCable.server => "/cable"

    mount ApplicationAPI, at: '/'
    mount GrapeSwaggerRails::Engine, at: '/explorer'
  end

  constraints(subdomain: App.host('admin'))  do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

    root 'dashboard#index'

    resources :systems do
      collection do
        get '/', to: 'dashboard#index'
        get '/loot', to: 'dashboard#loot'

        resources :announcements
        resources :loots, only: [:index, :update]
        resources :ledgers
        resources :programs do
          put 'toggle_status', on: :member
        end
        resources :templates do
          member do
            get 'end_contest'
          end
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
        get '/subscribes', to: 'users#subscribes'
        resources :users do
          get '/winners', to: 'users#winners'
        end
        resources :gems
      end
    end
  end

  constraints(subdomain: App.host(''))  do
    root 'landing#index'
  end
end

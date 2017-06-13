Rails.application.routes.draw do
  resources :adverts
  get 'landing/index'
  post 'landing/subscribes'

  constraints(subdomain: App.host('api')) do
    mount Sidekiq::Web => '/workers'
    mount ActionCable.server => "/cable"

    mount DefaultAPI, at: '/'
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
        resources :promos

        get '/subscribes', to: 'users#subscribes'
        resources :users do
          get '/winners', to: 'users#winners'
          get '/contests', to: 'users#contests'
          get '/contests_show', to: 'user#contests_show'
          get '/transactions', to: 'users#transactions'
          get '/prizes', to: 'users#prizes'
          put '/prize_complete', to: 'users#prize_complete'
        end
        resources :gems
        resources :adverts do
          collection do
            get 'giveaways'
            post 'giveaways', to: 'adverts#giveaways_checked'
          end
        end

        resources :contests
      end
    end
  end

  constraints(subdomain: App.host(''))  do
    root 'landing#show'
  end
end

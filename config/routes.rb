Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, :controllers => {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  get 'users', to: redirect('users/sign_in')
  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: :login
  end

  # resources :programs do
  #   resources :templates do
  #   end
  # end
end

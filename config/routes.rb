Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # devise_for :users, :controllers => {
  #   omniauth_callbacks: "users/omniauth_callbacks",
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations'
  # }
  devise_for :users

  # resources :programs do
  #   resources :templates do
  #   end
  # end
end

Rails.application.routes.draw do
  get 'profile', to: 'profile#index'
  get 'profile/edit'
  patch 'profile/update'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  authenticated :user do
    root to: 'home#index', as: :authenticated_root
  end
  root to: 'home#public'
end

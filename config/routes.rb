require 'api_version_constraint'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, path: '/', constraints: { subdomain: 'api' }, defaults: { format: :json } do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1) do
      mount_devise_token_auth_for 'User', at: 'auth', :controllers => { registrations: 'api/v1/registrations' }

      post 'profile/roles', to: 'users#add_roles'
      delete 'profile/roles/:id', to: 'users#remove_role'
      resources :users, only: [:index]

      resources :roles, only: [:index]
      resources :songs
      resources :groups do
        resources :songs
        resources :members, only: [:create, :update, :destroy]
        resources :presentations, only: [:index, :create, :show, :update, :destroy] do
          resources :members, only: [:create, :update, :destroy], controller: :presentations_members
          resources :songs, only: [:create, :update, :destroy], controller: :presentations_songs
          resources :rehearsals, only: [:create, :update, :destroy]
        end
      end
    end
  end
end

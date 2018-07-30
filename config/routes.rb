require 'api_version_constraint'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, path: '/', defaults: { format: :json } do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1) do
      mount_devise_token_auth_for 'User', at: 'auth', :controllers => { registrations: 'api/v1/registrations' }

      resources :instruments, only: [:index]
      resources :musics
      resources :groups do
        resources :musics
        resources :members, only: [:create, :update, :destroy]
      end
    end
  end
end

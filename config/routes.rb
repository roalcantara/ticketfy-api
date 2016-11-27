Rails.application.routes.draw do
  mount_devise_token_auth_for 'Admin', at: 'admin_auth', skip: [:omniauth_callbacks]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :admins
    end
  end
end

Rails.application.routes.draw do
  mount_devise_token_auth_for 'Admin', at: 'admin_auth', skip: [:omniauth_callbacks]
  mount_devise_token_auth_for 'Agent', at: 'agent_auth', skip: [:omniauth_callbacks]
  mount_devise_token_auth_for 'Customer', at: 'customer_auth', skip: [:omniauth_callbacks]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :admins
      resources :agents
      resources :customers
    end
  end
end
